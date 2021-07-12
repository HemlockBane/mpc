package com.teamapt.customers.moniepoint.lib.camera

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.ImageFormat
import android.hardware.camera2.*
import android.media.CamcorderProfile
import android.media.ImageReader
import android.os.Build
import android.util.Size
import androidx.annotation.RequiresApi
import io.flutter.plugins.camera.Camera

@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
class CustomCamera(
        private val context: Context,
        private val cameraName: String,
        private val resolutionPreset: ResolutionPreset) {


    private var captureSize: Size
    private var previewSize: Size

    private var cameraManager: CameraManager? = null
    private var recordingProfile: CamcorderProfile? = null
    private var pictureImageReader: ImageReader? = null
    private var imageStreamReader: ImageReader? = null

    private var cameraCharacteristics: CameraCharacteristics? = null
    private var cameraCaptureSession: CameraCaptureSession? = null
    private var captureRequestBuilder: CaptureRequest.Builder? = null

    init {
        this.cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        this.recordingProfile = CustomCameraUtils.getBestAvailableCamcorderProfileForResolutionPreset(cameraName, resolutionPreset)
        this.captureSize = Size(recordingProfile!!.videoFrameWidth, recordingProfile!!.videoFrameHeight)
        this.previewSize = Size(recordingProfile!!.videoFrameWidth, recordingProfile!!.videoFrameHeight)
    }

    /**
     * Specify the imageFormat the camera should process
     */
    @SuppressLint("MissingPermission")
    fun startCamera(imageFormatGroup: String) {
        pictureImageReader = ImageReader
                .newInstance(captureSize.width, captureSize.height, ImageFormat.JPEG, 2)

        var imageFormat = supportedImageFormats[imageFormatGroup]
        if(imageFormat == null) {
            imageFormat = ImageFormat.YUV_420_888
        }

        imageStreamReader = ImageReader.newInstance(previewSize.width, previewSize.height, imageFormat, 2)

        cameraManager?.openCamera("front",
                object: CameraDevice.StateCallback() {
                    override fun onOpened(camera: CameraDevice) {

                    }

                    override fun onDisconnected(camera: CameraDevice) {
                        
                    }

                    override fun onError(camera: CameraDevice, error: Int) {

                    }
                },
                null)
    }

    companion object {
        val supportedImageFormats = mapOf<String, Int>(
                "jpeg" to 256,
                "yuv420" to 35
        )
    }
}

