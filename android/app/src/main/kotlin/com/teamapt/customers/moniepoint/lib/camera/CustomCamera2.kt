package com.teamapt.customers.moniepoint.lib.camera

import android.content.Context
import android.util.Size
import android.view.Surface
import androidx.camera.core.CameraSelector
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.Preview
import androidx.camera.core.UseCase
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import java.lang.Exception
import java.util.concurrent.ExecutionException
import java.util.concurrent.Executors

class CustomCamera2(
        private val context: Context,
        private val surfaceProvider: Preview.SurfaceProvider
) {

    fun startCamera(vararg useCases: UseCase) {
        val cameraProviderListenable = ProcessCameraProvider.getInstance(context)
        cameraProviderListenable.addListener({
            var cameraProvider: ProcessCameraProvider? = null
            try {
                cameraProvider = cameraProviderListenable.get()
            } catch (ex: ExecutionException) {
                ex.printStackTrace()
            } catch (ex: InterruptedException) {
                ex.printStackTrace()
            }

            val preview = Preview.Builder()
                    .setTargetRotation(Surface.ROTATION_0)
                    .build()

//            val imageAnalysis = ImageAnalysis.Builder()
//                    .setTargetResolution(Size(1280, 720))
//                    .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
//                    .build()
//
//            imageAnalysis.setAnalyzer(Executors.newSingleThreadExecutor(), {
//            })

            preview.setSurfaceProvider(surfaceProvider)

            val cameraSelector = CameraSelector.Builder()
                    .requireLensFacing(CameraSelector.LENS_FACING_FRONT)
                    .build()

            try {
                cameraProvider?.unbindAll()
                cameraProvider?.bindToLifecycle(
                        context as LifecycleOwner,
                        cameraSelector,
                        preview, *useCases
                )
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(context))
    }

}