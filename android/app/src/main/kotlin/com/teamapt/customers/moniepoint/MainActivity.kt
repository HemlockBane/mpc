package com.teamapt.customers.moniepoint

import android.annotation.SuppressLint
import android.os.Build
import androidx.annotation.RequiresApi
import com.teamapt.customers.moniepoint.lib.BiometricMethodHandler
import com.teamapt.customers.moniepoint.lib.LivelinessMethodHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class   MainActivity: FlutterFragmentActivity() {

    companion object {
        private const val LIVELINESS_CHANNEL = "moniepoint.flutter.dev/liveliness"
        private const val LIVELINESS_EVENT_CHANNEL = "moniepoint.flutter.dev/liveliness/events"
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
        //Listens for the motion detection events
        val livelinessMethodHandler = LivelinessMethodHandler(this, flutterEngine.renderer.createSurfaceTexture())

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, LIVELINESS_EVENT_CHANNEL)
                .setStreamHandler(livelinessMethodHandler.LivelinessEvenChannel())

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LIVELINESS_CHANNEL)
                .setMethodCallHandler(livelinessMethodHandler)
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
