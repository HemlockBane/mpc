package com.teamapt.customers.moniepoint.lib

import android.os.Build
import androidx.fragment.app.FragmentActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class BiometricMethodHandler(private val mActivity: FragmentActivity) : MethodChannel.MethodCallHandler {

    private lateinit var biometricChannel: BiometricChannel
    
    override fun onMethodCall(call: MethodCall, reply: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> initialize(call, reply)
            "isFingerPrintAvailable" -> isFingerprintAvailable(call, reply)
            "get_biometric_type" -> getBiometricType(call, reply)
            "get_finger_print_password" -> getFingerprintPassword(call, reply)
            "remove_finger_print_password" -> removeFingerprintPassword(call, reply)
        }
    }
    
    private fun initialize(call: MethodCall, reply: MethodChannel.Result) {
        val keyFileName = call.argument<String>("keyFileName")
        val keyStoreName = call.argument<String>("keyStoreName")
        val keyAlias = call.argument<String>("keyAlias")
        if (keyAlias == null || keyFileName == null || keyStoreName == null) {
            return reply.error("01", "keystore can't null", "")
        }
        biometricChannel = BiometricChannel(mActivity, keyFileName, keyStoreName, keyAlias)
        reply.success(true)
    }

    private fun isFingerprintAvailable(call: MethodCall, reply: MethodChannel.Result) {
        val pair = biometricChannel.isFingerPrintAuthAvailable()
        reply.success(mapOf("availability" to pair.first, "extra_message" to pair.second))
    }

    private fun getFingerprintPassword(call: MethodCall, reply: MethodChannel.Result) {
        val password = biometricChannel.getFingerprintPassword()
        reply.success(password)
    }

    private fun removeFingerprintPassword(call: MethodCall, reply: MethodChannel.Result) {
        biometricChannel.deleteFingerprintPassword()
        reply.success(true)
    }

    private fun getBiometricType(call: MethodCall, reply: MethodChannel.Result) {
        val pair = biometricChannel.isFingerPrintAuthAvailable()
        if (pair.first) {
            reply.success(mapOf("biometric_type" to "FACE_ID"))
        } else {
            reply.success(mapOf("biometric_type" to "NONE"))
        }
    }

    inner class BiometricStreamHandler : EventChannel.StreamHandler {
        override fun onListen(listener: Any?, events: EventChannel.EventSink?) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val map = listener as Map<String, String>
                biometricChannel.startFingerPrintForMode(
                        mActivity = mActivity,
                        authenticate = true,
                        authenticationMode = AuthenticationType.valueOf(map["authType"] ?: "SetUp"),
                        authenticationCallback = { fingerPrintKey, b ->
                            events?.success(mapOf(
                                    "fingerPrintKey" to fingerPrintKey,
                                    "extraMessage" to b
                            ))
                        }
                )
            } else {
                events?.error("01", "Unsupported", "")
            }
        }

        override fun onCancel(listener: Any?) {
            println("Cancelling")
        }
    }
}