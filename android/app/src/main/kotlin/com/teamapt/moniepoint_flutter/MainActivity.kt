package com.teamapt.moniepoint_flutter

import android.graphics.BitmapFactory
import com.amplifyframework.core.Amplify
import com.amplifyframework.predictions.models.IdentifyActionType
import com.amplifyframework.predictions.result.IdentifyEntitiesResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "moniepoint.flutter.dev/liveliness"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, reply ->
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

}
