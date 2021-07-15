package com.teamapt.customers.moniepoint.lib.camera

import android.content.Context
import androidx.core.content.ContextCompat
import com.teamapt.customers.moniepoint.lib.camera.event.CameraMotionEvent
import com.teamapt.customers.moniepoint.lib.camera.event.FaceDetectedEvent
import com.teamapt.customers.moniepoint.lib.camera.event.MotionDetectedEvent
import com.teamapt.customers.moniepoint.lib.camera.event.NoFaceDetectedEvent
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

class LivelinessMethodHandler(
        private val context: Context,
        private val textureEntry: TextureRegistry.SurfaceTextureEntry
) : MethodChannel.MethodCallHandler {
    
    private var livelinessDetector: LivelinessDetector? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "create" -> initializeCamera(result)
            "start" -> {
                livelinessDetector?.startPreview()
                result.success("started")
            }
            "pause" -> {
                livelinessDetector?.pauseListening()
                result.success("")
            }
            "resume" -> {
                livelinessDetector?.resumeListening()
                result.success("")
            }
            "close" -> {
                livelinessDetector?.stopCamera()
                result.success("")
            }
        }
    }

    private fun initializeCamera(reply: MethodChannel.Result) {
        val flutterSurfaceProvider = FlutterSurfaceProvider(textureEntry, ContextCompat.getMainExecutor(context))
        val customCamera = CustomCamera2(context, flutterSurfaceProvider)
        this.livelinessDetector = LivelinessDetector(context, customCamera)
        reply.success(hashMapOf<String, Any>("cameraId" to textureEntry.id()))
    }

    /**
     *
     */
    inner class LivelinessEvenChannel: EventChannel.StreamHandler {

        private var eventSink: EventChannel.EventSink? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            this.eventSink = events
            livelinessDetector?.startListening {
                ContextCompat.getMainExecutor(context).execute {
                    sendEvent(it)
                }
            }
        }

        override fun onCancel(arguments: Any?) {
            eventSink = null
        }

        private fun sendEvent(cameraMotionEvent: CameraMotionEvent) {
            when(cameraMotionEvent) {
                is FaceDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "file_path" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                is NoFaceDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "file_path" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                is MotionDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "file_path" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                else -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                            )
                    )
                }
            }
        }

    }
}