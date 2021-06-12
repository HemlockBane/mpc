package com.teamapt.moniepoint_flutter

import android.graphics.BitmapFactory
import android.os.Build
import androidx.annotation.RequiresApi
import com.amplifyframework.core.Amplify
import com.amplifyframework.predictions.models.IdentifyActionType
import com.amplifyframework.predictions.result.IdentifyEntitiesResult
import com.teamapt.moniepoint_flutter.lib.BiometricMethodHandler
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.*

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

    private fun registerLivelinessDetector(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LIVELINESS_CHANNEL).setMethodCallHandler { call, reply ->
            when(call.method) {
                "analyzeImage" -> {
                    val byteArray = call.argument<ByteArray>("imageByte")
                    val bitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray!!.size)
                    val mapResult = hashMapOf<String, Any>()

                    Amplify.Predictions.identify(IdentifyActionType.DETECT_ENTITIES, bitmap, { mResult ->

                        val identifyResult = mResult as IdentifyEntitiesResult

                        if(identifyResult.entities.isNullOrEmpty()) {
                            mapResult["facenotdetected"] = mapOf("value" to true, "confidence" to 100.0)
                            this.runOnUiThread { reply.success(mapResult) }
                            return@identify;
                        }

                        mapResult["numberOfFaces"] = identifyResult.entities.size

                        identifyResult.entities.forEach {
                            val pose = it.pose

                            if (pose != null) {
                                mapResult["pose"] = mapOf(
                                        "yaw" to pose.yaw,
                                        "roll" to pose.roll,
                                        "pitch" to pose.pitch,
                                )
                            }

//                            it.emotions.forEach { emotion ->
//                                mapResult[emotion.typeAlias] = mapOf(
//                                        "value" to emotion.value,
//                                        "confidence" to emotion.confidence
//                                )
//                            }

                            it.values.forEach { feature ->
                                mapResult[feature.typeAlias.toLowerCase(Locale.ROOT)] = mapOf(
                                        "value" to feature.value,
                                        "confidence" to feature.confidence
                                )
                            }

                            mapResult["box"] = mapOf(
                                    "height" to it.box?.height(),
                                    "width" to it.box?.width(),
                                    "right" to it.box?.right,
                                    "left" to it.box?.left,
                                    "bottom" to it.box?.bottom,
                                    "top" to it.box?.top,
                            )


                        }

                        this.runOnUiThread {
                            reply.success(mapResult)
                        }
                    }, {
                        it.printStackTrace()
                        mapResult["error"] = mapOf("message" to it.message)
                        this.runOnUiThread {
                            reply.success(mapResult)
                        }
                    })
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
