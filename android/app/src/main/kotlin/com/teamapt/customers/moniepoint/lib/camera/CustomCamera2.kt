package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.content.Context
import android.hardware.camera2.*
import android.hardware.camera2.params.StreamConfigurationMap
import android.util.Size
import android.view.Surface
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import com.teamapt.customers.moniepoint.lib.camera.bioid.Rotation
import java.lang.Exception
import java.util.concurrent.ExecutionException
import java.util.concurrent.Executors

class CustomCamera2(
        private val context: Context,
        private val surfaceProvider: Preview.SurfaceProvider
) {

    private var cameraProvider: ProcessCameraProvider? = null

    fun getContext() : Context = context
    
    @SuppressLint("UnsafeOptInUsageError", "RestrictedApi")
    fun startCamera(vararg useCases: UseCase) {
        val cameraProviderListenable = ProcessCameraProvider.getInstance(context)
        cameraProviderListenable.addListener({
            try {
                cameraProvider = cameraProviderListenable.get()
            } catch (ex: ExecutionException) {
                ex.printStackTrace()
            } catch (ex: InterruptedException) {
                ex.printStackTrace()
            }

            val preview = Preview.Builder()
                    .setTargetRotation(context.display?.rotation ?: Surface.ROTATION_0)
                    .setTargetAspectRatio(AspectRatio.RATIO_4_3)
                    .build()

            preview.setSurfaceProvider(surfaceProvider)

            val cameraSelector = CameraSelector.Builder()
                    .requireLensFacing(CameraSelector.LENS_FACING_FRONT)
                    .build()
            try {
                cameraProvider?.unbindAll()
                val camera = cameraProvider?.bindToLifecycle(
                        context as LifecycleOwner,
                        cameraSelector,
                        preview, *useCases
                )

                val exposureState = camera?.cameraInfo?.exposureState
                if(exposureState?.isExposureCompensationSupported == true) {
                    val exposureRange = exposureState.exposureCompensationRange
                    println("Range of exposure is $exposureRange")

                    if(exposureRange.contains(4)) {
                        println("Setting Range of exposure is 0")
                        camera.cameraControl.setExposureCompensationIndex(20)
                    }
                }
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
        }, ContextCompat.getMainExecutor(context))
    }
    
    fun stopCamera() {
        cameraProvider?.unbindAll()
    }

    companion object {
        @Throws(CameraAccessException::class)
        fun getAvailableCameras(context: Context) : List<CameraDescription> {
            val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
            val cameraIds = cameraManager.cameraIdList
            val cameraDescriptions = arrayListOf<CameraDescription>()

            cameraIds.forEach {
                val cameraCharacteristic = cameraManager.getCameraCharacteristics(it)
                val sensorOrientation = cameraCharacteristic.get(CameraCharacteristics.SENSOR_ORIENTATION)
                val lensFacing = when(cameraCharacteristic.get(CameraCharacteristics.LENS_FACING)) {
                    CameraMetadata.LENS_FACING_FRONT -> CameraMetadata.LENS_FACING_FRONT
                    CameraMetadata.LENS_FACING_BACK -> CameraMetadata.LENS_FACING_BACK
                    CameraMetadata.LENS_FACING_EXTERNAL -> CameraMetadata.LENS_FACING_EXTERNAL
                    else -> -1
                }
                cameraDescriptions.add(CameraDescription(it, sensorOrientation = sensorOrientation!!, lensFacing = lensFacing))
            }
            return cameraDescriptions
        }
    }

}