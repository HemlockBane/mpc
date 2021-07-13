package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.FaceDetector
import android.media.Image
import android.os.Build
import android.os.Environment
import android.util.Size
import android.view.Surface
import androidx.annotation.RequiresApi
import androidx.annotation.WorkerThread
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.internal.YuvToJpegProcessor
import com.teamapt.customers.moniepoint.lib.camera.bioid.MotionDetection
import com.teamapt.customers.moniepoint.lib.camera.bioid.Rotation
import com.teamapt.customers.moniepoint.lib.camera.bioid.Yuv420Image
import com.teamapt.customers.moniepoint.lib.camera.event.*
import java.io.BufferedOutputStream
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.Executors

@SuppressLint("UnsafeOptInUsageError")
@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class LivelinessDetector (private val context: Context, private val camera: CustomCamera2, private val eventHandler: (event: CameraMotionEvent) -> Unit) {

    private var first: Image? = null
    private var second: Image? = null

    private val imageAnalysisUseCase: ImageAnalysis
    private val converter = YuvToRgbConverter(context)

    init {
        println("initialized liveliness detector was called")
        imageAnalysisUseCase = ImageAnalysis.Builder()
                .setTargetRotation(Surface.ROTATION_0)
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build()
        val motionDetection = MotionDetection()
        imageAnalysisUseCase.setAnalyzer(Executors.newSingleThreadExecutor(), {
            val image = it.image ?: return@setAnalyzer
            val yuvImage = Yuv420Image.copyFrom(image, 0, context)
            if (first == null && isFaceDetected(image)) {
                println("Capturing first face")
                first = image

                motionDetection.createTemplate(yuvImage)
                eventHandler.invoke(FaceDetectedEvent(null))
            } else if(first != null) {
                //we are set to compare the second image
                if (isFaceDetected(image)) {
                    val motionDetected = motionDetection.detect(yuvImage)
                    if (motionDetected) eventHandler.invoke(MotionDetectedEvent(null))
                } else {
                    motionDetection.resetTemplate()
                    first = null
                }
            } else {
                println("No Face")
            }
            it.close()
        })
    }

    fun start() {
        camera.startCamera(imageAnalysisUseCase)
    }


    @WorkerThread
    private fun isFaceDetected(image: Image): Boolean {
        val bitmap = Bitmap.createBitmap(image.width, image.height, Bitmap.Config.ARGB_8888)
        
        converter.yuvToRgb(image, bitmap)
        
        val faces = arrayOfNulls<FaceDetector.Face>(1)
        
//        bitmap.config = Bitmap.Config.RGB_565
        val outputStream = FileOutputStream(File(context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS),"motion.jpg"))
        val bStream = BufferedOutputStream(outputStream)
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bStream)
        outputStream.close()
        
        FaceDetector(bitmap.width, bitmap.height, 1).findFaces(bitmap, faces)
        
        faces.forEach { 
            println("Face Confidence is ${it?.confidence()}")
        }
        return faces.filterNotNull().map { it.confidence() >= 0.5 }.firstOrNull() ?: false
    }
    
}