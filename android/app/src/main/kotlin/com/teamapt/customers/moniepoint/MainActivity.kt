package com.teamapt.customers.moniepoint

import android.annotation.SuppressLint
import android.hardware.camera2.CameraMetadata
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.teamapt.customers.moniepoint.lib.BiometricMethodHandler
import com.teamapt.customers.moniepoint.lib.camera.*
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class   MainActivity: FlutterFragmentActivity() {
    companion object {
        private const val LIVELINESS_CHANNEL = "moniepoint.flutter.dev/liveliness"
        private const val BIOMETRIC_CHANNEL = "moniepoint.flutter.dev/biometric"
        private const val BIOMETRIC_EVENT_CHANNEL = "moniepoint.flutter.dev/biometric_auth"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        registerLivelinessDetector(flutterEngine)
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) registerBiometricChannel(flutterEngine)
    }

    @SuppressLint("NewApi")
    private fun registerLivelinessDetector(flutterEngine: FlutterEngine) {
        var count = 0
        var customCamera: CustomCamera2?
        var livelinessDetector: LivelinessDetector? = null
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LIVELINESS_CHANNEL).setMethodCallHandler { call, reply ->
            when(call.method) {
                "create" -> {
                    println("Create was called")
                    val availableCamera = CustomCamera.getAvailableCameras(this)
                    val camera = availableCamera.first { it.lensFacing == CameraMetadata.LENS_FACING_FRONT }
                    val flutterSurfaceView = flutterEngine.renderer.createSurfaceTexture()
                    customCamera = CustomCamera2(this, FlutterCameraProvider(flutterSurfaceView, ContextCompat.getMainExecutor(this)))
                    livelinessDetector = LivelinessDetector(this, customCamera!!) { event -> }
                    reply.success(hashMapOf<String, Any>("cameraId" to flutterSurfaceView.id()))
                }
                "initialize" -> {
                    println("initialized was called")

                    livelinessDetector?.start()
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.M)
    private fun registerBiometricChannel(flutterEngine: FlutterEngine) {
        val biometricMethodHandler = BiometricMethodHandler(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BIOMETRIC_CHANNEL)
                .setMethodCallHandler(biometricMethodHandler)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BIOMETRIC_EVENT_CHANNEL)
                .setStreamHandler(biometricMethodHandler.BiometricStreamHandler())
    }

}
