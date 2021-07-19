package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.graphics.*
import android.media.FaceDetector
import android.media.Image
import android.os.Build
import android.view.Surface
import androidx.annotation.RequiresApi
import androidx.annotation.WorkerThread
import androidx.camera.core.AspectRatio
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageInfo
import com.teamapt.customers.moniepoint.lib.camera.bioid.MotionDetection
import com.teamapt.customers.moniepoint.lib.camera.bioid.Yuv420Image
import com.teamapt.customers.moniepoint.lib.camera.event.*
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.util.concurrent.Executors

/**
 * @author Paul Okeke
 */
@SuppressLint("UnsafeOptInUsageError", "RestrictedApi")
@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class LivelinessDetector private constructor(
        private val camera: CustomCamera2,
        private val frameSize: Rect? = null,
        private val shouldCropCapture: Boolean,
        private val faceDetectionConfidenceLevel: Double,
        private val verticalAlignmentThreshold: Double = 0.8,
        private val horizontalAlignmentThreshold: Double = 0.8,
) {

    private var first: Image? = null
    private var second: Image? = null
    private var pauseListening = false

    private val eyeMidPoint = PointF()
    private var eyeDistance = 0f
    private var eventHandler: (event: CameraMotionEvent) -> Unit = {}

    private val imageAnalysisUseCase: ImageAnalysis = ImageAnalysis.Builder()
            .setTargetRotation(Surface.ROTATION_0)
            .setTargetAspectRatio(AspectRatio.RATIO_4_3)
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()
    
    private val converter = YuvToRgbConverter(camera.getContext())

    fun pauseListening() {
        this.pauseListening = true
    }

    fun resumeListening() {
        this.pauseListening = false
    }

    fun restartCapture() {
        first = null
        second = null
        this.pauseListening = false
        eyeMidPoint.set(0f, 0f)
    }
    
    fun stopCamera() {
        first = null
        second = null
        pauseListening = false
        camera.stopCamera()
        eyeMidPoint.set(0f, 0f)
        //TODO remove all images
        System.gc() //TODO remove
    }

    /**
     * Start listening for images
     */
    fun startListening(eventHandler: (event: CameraMotionEvent) -> Unit) {
        this.eventHandler = eventHandler
        val motionDetection = MotionDetection()

        imageAnalysisUseCase.setAnalyzer(Executors.newSingleThreadExecutor(), {
            if (pauseListening) {
                it.close()
                return@setAnalyzer
            }

            val image = it.image ?: return@setAnalyzer
            val yuvImage = Yuv420Image.copyFrom(image, 0, camera.getContext())

            var imageBitmap = Bitmap.createBitmap(image.width, image.height, Bitmap.Config.ARGB_8888)

            converter.yuvToRgb(image, imageBitmap)

            println("Original ImageWidth ${imageBitmap.width} and ImageHeight ${imageBitmap.height}")

            imageBitmap = adjustImageOrientation(imageBitmap, it.imageInfo)

            println("Adjusted ImageWidth ${imageBitmap.width} and Adjusted ImageHeight ${imageBitmap.height}")

            val passesGeneralProblems = validateGeneralProblems(imageBitmap, it.imageInfo)

            if (first == null && passesGeneralProblems) {
                first = image
                val savedImage = saveImageToDisk(imageBitmap, it.imageInfo)
                motionDetection.createTemplate(yuvImage)
                eventHandler.invoke(FirstCaptureEvent(savedImage))
            } else if (first != null && passesGeneralProblems) {
                val motionDetected = motionDetection.detect(yuvImage)
                if (motionDetected) {
                    pauseListening()
                    val savedImage = saveImageToDisk(imageBitmap, it.imageInfo, prefix = "MOTION_CAP_")
                    second = image
                    eventHandler.invoke(MotionDetectedEvent(savedImage))
                    it.close()
                    return@setAnalyzer
                } else {
                    eventHandler.invoke(NoMotionDetectedEvent(null))
                }
                println("Is Motion Detected.... $motionDetected")
            }

            it.close()
        })
    }

    private fun adjustImageOrientation(imageSourceBitmap: Bitmap, imageInfo: ImageInfo): Bitmap {
        val targetOrientation = camera.getContext().display?.rotation
        if(targetOrientation == Surface.ROTATION_0 && (imageInfo.rotationDegrees == 270)) {
            val rotateImage = imageSourceBitmap.rotate(-90f)
            imageSourceBitmap.recycle()
            return rotateImage
        }
        return imageSourceBitmap
    }

    /**
     * 
     */
    fun startPreview() {
        camera.startCamera(imageAnalysisUseCase)
    }

    private fun saveImageToDisk(bitmap: Bitmap, imageInfo: ImageInfo? = null,
                                cropCapture: Boolean = shouldCropCapture, prefix: String = "FIRST_CAP_"): File {
        val tempFile = File.createTempFile(prefix, ".jpg", camera.getContext().cacheDir)
        val fileOutputStream = FileOutputStream(tempFile)
        val bOutputStream = BufferedOutputStream(fileOutputStream)
        try {
            if(cropCapture && this.frameSize != null && imageInfo != null) {
                val mBitmap = cropImageToFrameSize(bitmap)
                mBitmap.compress(Bitmap.CompressFormat.JPEG, 100, bOutputStream)
                bitmap.recycle()
                mBitmap.recycle()
            } else {
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bOutputStream)
            }
        } catch (ex: IOException) {
            ex.printStackTrace()
        } finally {
            bOutputStream.flush()
        }
        return tempFile
    }

    private fun cropImageToFrameSize(bitmap: Bitmap): Bitmap {
        if(frameSize == null) return bitmap
        val frameWidth = frameSize.width()
        val frameHeight = frameSize.height()

        val cropSpaceX = if(frameWidth > bitmap.width) 0 else  bitmap.width - frameWidth
        val left = cropSpaceX / 2
        val right = bitmap.width - left

        val top = if(frameSize.top > bitmap.height) bitmap.height else frameSize.top
        val bottom = if(bitmap.height > frameSize.bottom) frameSize.bottom else bitmap.height

        val adjustedFrameSize: Rect?

        adjustedFrameSize = Rect(left, top, right, bottom)

        return bitmap.crop(adjustedFrameSize)
    }

    /**
     * @author Paul Okeke
     * We are converting this here to a grayscale image
     * since the format received from the imageAnalyses is in YUV(YcbYcr) format
     * thus we need an RGB_565 format for it to be able to work with the FaceDetector.findFaces
     *
     * TODO check if this consumes much memory
     */
    private fun toGrayscale(bmpOriginal: Bitmap): Bitmap {
        val height: Int = bmpOriginal.height
        val width: Int = bmpOriginal.width
        val bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565)
        val c = Canvas(bmpGrayscale)
        val paint = Paint()
        val cm = ColorMatrix()
        cm.setSaturation(0f)
        val f = ColorMatrixColorFilter(cm)
        paint.colorFilter = f
        c.drawBitmap(bmpOriginal, 0f, 0f, paint)
        return bmpGrayscale
    }

    /**
     * To have some understanding of facial proportions you can read the below resources
     *
     * @see
     * https://www.thedrawingsource.com/proportions-of-the-face.html
     * https://www.artyfactory.com/portraits/pencil-portraits/proportions-of-a-head.html
     * https://www.her.ie/beauty/these-are-the-dimensions-for-a-perfect-face-according-to-old-school-science-243546
     */
    private fun isFaceWithinFrameSize(imageBitmap: Bitmap, imageInfo: ImageInfo): Boolean {
        if(this.frameSize == null) return true
        val croppedImage = cropImageToFrameSize(imageBitmap)
        val frameMidPoint = PointF()
        val isFaceDetected = isFaceDetected(croppedImage, frameMidPoint)

        if(!isFaceDetected) return false

        // To properly place the Y axis within the desired frame
        // We need to consider the forehead and ensure that face fits
        // within the frame vertically. We can make some general facial proportional assumptions here
        // using the golden ratio

        val eyeMidPointX = frameMidPoint.x
        val eyeMidPointY = frameMidPoint.y

        println("FrameSize Check midX => $eyeMidPointX , midY => $eyeMidPointY, eyeDistance => $eyeDistance")

        //TODO factor in the hairline
        val eyeToHeadDistance = eyeMidPointY - (eyeDistance * 1.5)
        val lengthOfTwoNose = (eyeDistance * 1.5) * 2
        val headLengthFromMidPoint = eyeMidPointY + lengthOfTwoNose

        val frameSizeMidPoint = frameSize.width() / 2
        val lowerXBound = horizontalAlignmentThreshold * frameSizeMidPoint
        val upperXBound = frameSizeMidPoint + (frameSizeMidPoint - (frameSizeMidPoint * horizontalAlignmentThreshold))

        if(eyeMidPointX > upperXBound || eyeMidPointX < lowerXBound) return false

        if((frameSize.top / eyeToHeadDistance) < verticalAlignmentThreshold) return false

        if((frameSize.height() / headLengthFromMidPoint) < verticalAlignmentThreshold) return false

        return true
    }

    /**
     * checks that the image passes all the test required
     * This will first check if a face exist before performing any other check
     *
     *
     * - FaceDetected
     * - Is face within the specified frame size, if a frameSize is specified
     * - Is the brightness level okay -- TODO
     */
    private fun validateGeneralProblems(imageBitmap: Bitmap, imageInfo: ImageInfo) : Boolean {
        val bitmap = toGrayscale(imageBitmap)

        if(!isFaceDetected(bitmap, eyeMidPoint)) {
            eventHandler.invoke(NoFaceDetectedEvent(null))
            return false
        }

        val prevEyeDistance = eyeDistance

        if(!isFaceWithinFrameSize(bitmap, imageInfo)) {
            eventHandler.invoke(FaceOutOfBoundsEvent)
            return false
        }

        //Reset the eyeDistance before capture
        eyeDistance = prevEyeDistance
        eventHandler.invoke(FaceDetectedEvent(null))

        return true
    }

    @WorkerThread
    private fun isFaceDetected(bitmap: Bitmap, midPoint: PointF? = null): Boolean {
        val faces = arrayOfNulls<FaceDetector.Face>(1)

        FaceDetector(bitmap.width, bitmap.height, 1).findFaces(bitmap, faces)
        faces.forEach {
            if(midPoint != null) it?.getMidPoint(midPoint)
            eyeDistance = it?.eyesDistance() ?: 0f
            println("Face Confidence is ${it?.confidence()}")
            if(midPoint != null) println("Face Eyes Distance ${it?.eyesDistance()}")
            if(midPoint != null) println("Mid Point X=>${midPoint.x}, Y=>${midPoint.y}")
        }

        return faces.filterNotNull().map { it.confidence() >= faceDetectionConfidenceLevel }.firstOrNull() ?: false
    }


    data class Builder(private val camera: CustomCamera2, private var frameSize: Rect? = null) {
        private var shouldCropCapture: Boolean = true
        private var mConfidenceLevel = 0.514
        private var verticalAlignmentThreshold = 0.8
        private var horizontalAlignmentThreshold = 0.8

        fun setFrameSize(frameSize: Rect?) = apply { this.frameSize = frameSize }
        fun setCropCaptureToFrameSize(shouldCropCapture: Boolean) = apply { this.shouldCropCapture = shouldCropCapture }
        fun setFaceDetectionConfidenceLevel(confidenceLevel: Double) = apply { this.mConfidenceLevel = confidenceLevel }

        /**
         *
         */
        fun setVerticalAlignmentThreshold(verticalAlignmentThreshold: Double) = apply {
            this.verticalAlignmentThreshold = verticalAlignmentThreshold
        }

        /**
         *
         */
        fun setHorizontalAlignmentThreshold(horizontalAlignmentThreshold: Double) = apply {
            this.horizontalAlignmentThreshold = horizontalAlignmentThreshold
        }

        fun build(): LivelinessDetector {
            return LivelinessDetector(
                    camera,
                    frameSize = frameSize,
                    shouldCropCapture = shouldCropCapture,
                    faceDetectionConfidenceLevel = mConfidenceLevel
            )
        }
    }

}