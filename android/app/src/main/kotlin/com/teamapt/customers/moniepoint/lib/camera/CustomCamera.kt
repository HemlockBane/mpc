package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.Context
import android.graphics.ImageFormat
import android.hardware.camera2.*
import android.hardware.camera2.params.OutputConfiguration
import android.hardware.camera2.params.SessionConfiguration
import android.media.CamcorderProfile
import android.media.ImageReader
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.Size
import android.view.Surface
import androidx.annotation.RequiresApi
import com.teamapt.customers.moniepoint.lib.camera.event.*
import java.io.IOException
import java.util.*
import java.util.concurrent.Executors
import kotlin.reflect.KClass

/**
 * @author Paul Okeke
 *
 */

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class CustomCamera(
        private val context: Context,

        /**
         * The name of the camera.
         * The name can be retrieved from the cameraDescription
         * Example:
         * ``` customCamera.getAvailableCameras().forEach( cameraDescription ->
         *         if(cameraDescription.lensFacing == CameraMetadata.LENS_FACING_FRONT) {
         *             cameraName = cameraDescription.name
         *             return@forEach
         *         }
         *     )
         * ```
         */
        private val cameraName: String,

        /**
         * The surface to output the live feed from the camera
         * Example:
         * ```findViewById(R.id.surfaceView).holder.surface```
         */
        private val previewSurface: Surface,

        /**
         *
         */
        private val resolutionPreset: ResolutionPreset
) {
    
    private var captureSize: Size
    private var previewSize: Size

    private var cameraManager: CameraManager? = null
    private var recordingProfile: CamcorderProfile? = null
    private var pictureImageReader: ImageReader? = null
    private var imageStreamReader: ImageReader? = null

    private var cameraDevice: CameraDevice? = null
    private var cameraCharacteristics: CameraCharacteristics? = null
    private var cameraCaptureSession: CameraCaptureSession? = null
    private var captureRequestBuilder: CaptureRequest.Builder? = null
    
    private var cameraMotionEventDispatcher: CameraMotionEventDispatcher? = null

    init {
        this.cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        this.cameraCharacteristics = cameraManager?.getCameraCharacteristics(cameraName)
        this.recordingProfile = CustomCameraUtils.getBestAvailableCamcorderProfileForResolutionPreset(cameraName, resolutionPreset)
        this.captureSize = Size(recordingProfile!!.videoFrameWidth, recordingProfile!!.videoFrameHeight)
        this.previewSize = Size(recordingProfile!!.videoFrameWidth, recordingProfile!!.videoFrameHeight)
    }
    
    fun <E : CameraMotionEvent> registerEventHandler(event: Class<out E>, handler: CameraMotionEventHandler<E>) {
        if(cameraMotionEventDispatcher == null) {
            cameraMotionEventDispatcher = CameraMotionEventDispatcher()
        }
        cameraMotionEventDispatcher?.registerHandler(event, handler)
    }
    

    /**
     * Specify the imageFormat the camera should process
     */
    @SuppressLint("MissingPermission")
    fun startCamera(imageFormatGroup: String = "yuv420") {
        pictureImageReader = ImageReader
                .newInstance(captureSize.width, captureSize.height, ImageFormat.JPEG, 2)

        val imageFormat = supportedImageFormats.getOrElse(imageFormatGroup, { ImageFormat.YUV_420_888 })
        
        imageStreamReader = ImageReader
                .newInstance(previewSize.width, previewSize.height, imageFormat, 2)

        cameraManager?.openCamera(this.cameraName,
                object : CameraDevice.StateCallback() {
                    override fun onOpened(camera: CameraDevice) {
                        this@CustomCamera.cameraDevice = camera
                        try {
                            startPreview()
                            cameraMotionEventDispatcher?.dispatch(CameraInitializedEvent)
                        } catch (ex: CameraAccessException) {
                            cameraMotionEventDispatcher?.dispatch(CameraInitializationErrorEvent)
                            ex.printStackTrace()
                        }
                    }

                    override fun onDisconnected(camera: CameraDevice) {
                        close()
                        println("Disconnected Camera")
                        cameraMotionEventDispatcher?.dispatch(CameraDisconnectedEvent)
                    }

                    override fun onError(camera: CameraDevice, error: Int) {
                        println("Error connectiong camera $error")
                        cameraMotionEventDispatcher?.dispatch(CameraInitializationErrorEvent)
                        close()
                    }
                }, null
        )
    }

    @Throws(CameraAccessException::class)
    private fun startPreview() {
        if(pictureImageReader == null || pictureImageReader?.surface == null) return
        createCaptureSession(CameraDevice.TEMPLATE_PREVIEW, pictureImageReader!!.surface)
    }

    fun startPreviewWithStream() {
        createCaptureSession(CameraDevice.TEMPLATE_RECORD, imageStreamReader!!.surface)
        imageStreamReader?.setOnImageAvailableListener({reader ->
            val image = reader.acquireLatestImage() ?: return@setOnImageAvailableListener
            try {
                cameraMotionEventDispatcher?.dispatch(ImageStreamAvailable(image))
            } catch (io: IOException) {
                io.printStackTrace();
            } finally {
                image.close()
            }
        }, null)
    }

    @Throws(CameraAccessException::class)
    private fun createCaptureSession(templateType: Int, vararg surfaces: Surface) {
        closeCaptureSession()
        captureRequestBuilder = cameraDevice?.createCaptureRequest(templateType)

        captureRequestBuilder?.addTarget(previewSurface)

        val listOfSurfaces = listOf(*surfaces)
        if(templateType != CameraDevice.TEMPLATE_PREVIEW) {
            listOfSurfaces.forEach { captureRequestBuilder?.addTarget(it) }
        }

        //Lets get the session callback onConfigured and onConfiguredFailed
        val captureSessionCallback = object: CameraCaptureSession.StateCallback() {
            override fun onConfigured(session: CameraCaptureSession) {
                if(cameraDevice == null) {
                    println("Camera Device is null")
                    //TODO send an event here to depict that the camera was already closed
                    return
                }
                cameraCaptureSession = session

                triggerPreviewRequest({
                    println("successfully started session")
                }, {})
            }
            override fun onConfigureFailed(session: CameraCaptureSession) {
                cameraMotionEventDispatcher?.dispatch(CameraSessionConfigurationFailed())
            }
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val configs = arrayListOf<OutputConfiguration>()
            configs.add(OutputConfiguration(previewSurface))
            val moreConfigs = listOfSurfaces.map { OutputConfiguration(it) }
            configs.addAll(moreConfigs)
            createCaptureSessionWithSessionConfig(configs, captureSessionCallback)
        } else {
            val surfaceList = arrayListOf<Surface>()
            surfaceList.add(previewSurface)
            surfaceList.addAll(listOfSurfaces)
            createCaptureSession(surfaceList, captureSessionCallback)
        }

    }

    private fun triggerPreviewRequest(successCallback: () -> Unit, errorCallback: (errorMessage: String) -> Unit) {
        if(cameraCaptureSession == null) return;
        try {
            cameraCaptureSession?.setRepeatingRequest(
                    captureRequestBuilder!!.build(),
                    pictureCallback,
                    Handler(Looper.getMainLooper())
            )
            successCallback()
        } catch (ex: CameraAccessException) {
            ex.printStackTrace()
            Log.e("TAG", ex.message ?: "")
            errorCallback(ex.message ?: "")
        } catch (err2: IllegalAccessException) {
            err2.printStackTrace()
            errorCallback(err2.message ?: "")
        }
    }

    @RequiresApi(Build.VERSION_CODES.P)
    @Throws(CameraAccessException::class)
    private fun createCaptureSessionWithSessionConfig(outputConfiguration: List<OutputConfiguration>,
                                                      sessionCallback: CameraCaptureSession.StateCallback) {
        cameraDevice?.createCaptureSession(SessionConfiguration(
                SessionConfiguration.SESSION_REGULAR,
                outputConfiguration,
                Executors.newSingleThreadExecutor(),
                sessionCallback
        ))
    }

    @Suppress("DEPRECATION")
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    @Throws(CameraAccessException::class)
    private fun createCaptureSession(surfaces: List<Surface>,
                                     sessionCallback: CameraCaptureSession.StateCallback) {

        cameraDevice?.createCaptureSession(surfaces, sessionCallback, null)
    }

    private val pictureCallback = object : CameraCaptureSession.CaptureCallback() {
        override fun onCaptureCompleted(session: CameraCaptureSession, request: CaptureRequest, result: TotalCaptureResult) {
            super.onCaptureCompleted(session, request, result)
            Log.e("CaptureCompleted", "Capture Completed")
        }

        override fun onCaptureProgressed(session: CameraCaptureSession, request: CaptureRequest, partialResult: CaptureResult) {
            super.onCaptureProgressed(session, request, partialResult)
            Log.e("CaptureProgressed", "Capture Progressed")
        }

        override fun onCaptureFailed(session: CameraCaptureSession, request: CaptureRequest, failure: CaptureFailure) {
            Log.e("CaptureFailed", "Capture Failed")
        }
    }

    fun close() {
        closeCaptureSession()

        cameraDevice?.close()
        cameraDevice = null

        pictureImageReader?.close()
        pictureImageReader = null

        imageStreamReader?.close()
        imageStreamReader = null
    }

    private fun closeCaptureSession() {
        cameraCaptureSession?.close()
        cameraCaptureSession = null
    }

    companion object {
        val supportedImageFormats = mapOf<String, Int>(
                "jpeg" to 256,
                "yuv420" to 35
        )

        /**
         * Returns the list of available cameras
         */
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

