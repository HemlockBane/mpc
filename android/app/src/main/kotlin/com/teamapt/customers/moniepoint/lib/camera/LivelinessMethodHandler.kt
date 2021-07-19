package com.teamapt.customers.moniepoint.lib.camera

import android.content.Context
import android.graphics.Rect
import androidx.core.content.ContextCompat
import com.teamapt.customers.moniepoint.lib.camera.event.*
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
            "create" -> initializeCamera(call, result)
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
            "restart" -> {
                livelinessDetector?.restartCapture()
                result.success("")
            }
            "close" -> {
                livelinessDetector?.stopCamera()
                result.success("")
            }
        }
    }

    private fun initializeCamera(methodCall: MethodCall?, reply: MethodChannel.Result) {
        val flutterSurfaceProvider = FlutterSurfaceProvider(textureEntry, ContextCompat.getMainExecutor(context))
        val customCamera = CustomCamera2(context, flutterSurfaceProvider)
        var frameSize: Rect? = null
        val channelFrameSize = methodCall?.argument<Map<String?, Double?>>("frameSize")
        println("channelFrameSize $channelFrameSize")
        if(channelFrameSize != null) {
            val left = channelFrameSize["left"]
            val top = channelFrameSize["top"]
            val right = channelFrameSize["right"]
            val bottom = channelFrameSize["bottom"]

            if((left != null && left > 0)
                    && (top != null && top > 0)
                    && (right != null && right > 0)
                    && (bottom != null && bottom > 0)) {
                frameSize = Rect(left.toInt(), top.toInt(), right.toInt(), bottom.toInt())
            }
        }
        //let's check if the frameSize is supplied from the channel
        this.livelinessDetector = LivelinessDetector.Builder(customCamera)
                .setFrameSize(frameSize)
                .setCropCaptureToFrameSize(true)
                .setFaceDetectionConfidenceLevel(0.505)
                .setHorizontalAlignmentThreshold(0.8)
                .setVerticalAlignmentThreshold(0.8)
                .build()
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
                is FirstCaptureEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "file_path" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
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