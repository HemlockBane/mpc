package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.*
import android.media.FaceDetector
import android.media.Image
import android.os.Build
import android.view.Surface
import androidx.annotation.RequiresApi
import androidx.annotation.WorkerThread
import androidx.camera.core.ImageAnalysis
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
@SuppressLint("UnsafeOptInUsageError")
@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class LivelinessDetector(
        private val context: Context,
        private val camera: CustomCamera2) {

    private var first: Image? = null
    private var second: Image? = null
    private var pauseListening = false

    private val imageAnalysisUseCase: ImageAnalysis = ImageAnalysis.Builder()
            .setTargetRotation(Surface.ROTATION_0)
            .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
            .build()
    
    private val converter = YuvToRgbConverter(context)

    fun pauseListening() {
        this.pauseListening = true
    }

    fun resumeListening() {
        this.pauseListening = false
    }
    
    fun stopCamera() {
        camera.stopCamera()
    }

    /**
     * Start listening for images
     */
    fun startListening(eventHandler: (event: CameraMotionEvent) -> Unit) {
        val motionDetection = MotionDetection()
        imageAnalysisUseCase.setAnalyzer(Executors.newSingleThreadExecutor(), {
            if(pauseListening) {
                it.close()
                return@setAnalyzer
            }

            val image = it.image ?: return@setAnalyzer
            val yuvImage = Yuv420Image.copyFrom(image, 0, context)
            val imageBitmap = Bitmap.createBitmap(image.width, image.height, Bitmap.Config.ARGB_8888)

            converter.yuvToRgb(image, imageBitmap)

            val isFaceDetected = isFaceDetected(imageBitmap)

            if (first == null && isFaceDetected) {
                first = image
                val savedImage = saveImageToDisk(imageBitmap)
                motionDetection.createTemplate(yuvImage)
                eventHandler.invoke(FaceDetectedEvent(savedImage))
            } else if (first != null && isFaceDetected) {
                val motionDetected = motionDetection.detect(yuvImage)
                if (motionDetected) {
                    pauseListening()
                    val savedImage = saveImageToDisk(imageBitmap, prefix = "MOTION_CAP_")
                    second = image
                    eventHandler.invoke(MotionDetectedEvent(savedImage))
                    it.close()
                    return@setAnalyzer
                } else {
                    eventHandler.invoke(NoMotionDetected(null))
                }
                println("Is Motion Detected.... $motionDetected")
            } else {
                println("Dispatching no face detected")
                eventHandler.invoke(NoFaceDetectedEvent(null))
            }

            it.close()
        })
    }

    /**
     * 
     */
    fun startPreview() {
        camera.startCamera(imageAnalysisUseCase)
    }

    private fun saveImageToDisk(bitmap: Bitmap, prefix: String = "FIRST_CAP_"): File {
        val tempFile = File.createTempFile(prefix, ".jpg", context.cacheDir)
        val fileOutputStream = FileOutputStream(tempFile)
        val bOutputStream = BufferedOutputStream(fileOutputStream)
        try {
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bOutputStream)
            bOutputStream.flush()
        } catch (ex: IOException) {
            ex.printStackTrace()
        }
        return tempFile
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

    @WorkerThread
    private fun isFaceDetected(imageBitmap: Bitmap): Boolean {
        val bitmap = toGrayscale(imageBitmap)

        val faces = arrayOfNulls<FaceDetector.Face>(1)

        FaceDetector(bitmap.width, bitmap.height, 1).findFaces(bitmap, faces)

        faces.forEach {
            println("Face Confidence is ${it?.confidence()}")
        }
        return faces.filterNotNull().map { it.confidence() >= 0.5 }.firstOrNull() ?: false
    }

}