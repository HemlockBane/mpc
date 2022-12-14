package com.teamapt.customers.moniepoint.lib

import android.content.Context
import android.graphics.Rect
import android.util.Size
import android.view.Surface
import androidx.camera.core.Preview
import androidx.camera.core.SurfaceRequest
import androidx.core.content.ContextCompat
import com.teamapt.livelinessdetector.LivelinessDetector
import com.teamapt.livelinessdetector.camera.CustomCamera2
import com.teamapt.livelinessdetector.events.*
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry
import java.util.concurrent.Executor

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
            "begin_capture" -> {
                livelinessDetector?.beginCapture()
                result.success("")
            }
            "end_capture" -> {
                livelinessDetector?.endCapture()
                result.success("")
            }
            "restart" -> {
                livelinessDetector?.reset()
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
        var previewSize: Size? = null
        val channelFrameSize = methodCall?.argument<Map<String?, Double?>>("frameSize")
        val channelPreviewSize = methodCall?.argument<Map<String?, Double?>>("previewSize")
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
        if(channelPreviewSize != null) {
            val width = channelPreviewSize["width"]
            val height = channelPreviewSize["height"]

            if(width != null && height != null) {
                previewSize = Size(width.toInt(), height.toInt())
            }
        }
        //let's check if the frameSize is supplied from the channel
        this.livelinessDetector = LivelinessDetector.Builder(customCamera)
                .setFrameSize(frameSize)
                .setCropCaptureToFrameSize(false)
                .setFaceDetectionConfidenceLevel(0.505)
                .setCompressionQuality(80)
                .setFaceDistanceToFrameThreshold(0.5)
                .setPreviewSize(previewSize ?: Size(480, 640))
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
                                    "event_data" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                is FaceDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "event_data" to cameraMotionEvent.bitmap?.path,
                                    "exposure" to cameraMotionEvent.exposure
                            )
                    )
                }
                is NoFaceDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "event_data" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                is MotionDetectedEvent -> {
                    eventSink?.success(
                            hashMapOf<String?, Any?>(
                                    "event_type" to cameraMotionEvent.eventName,
                                    "event_data" to cameraMotionEvent.bitmap?.path
                            )
                    )
                }
                is ImageOverExposed -> {
                    eventSink?.success(
                        hashMapOf<String?, Any?>(
                            "event_type" to cameraMotionEvent.eventName,
                            "event_data" to cameraMotionEvent.exposure
                        )
                    )
                }
                is ImageUnderExposed -> {
                    eventSink?.success(
                        hashMapOf<String?, Any?>(
                            "event_type" to cameraMotionEvent.eventName,
                            "event_data" to cameraMotionEvent.exposure
                        )
                    )
                }
                is DetectedFaceRectEvent -> {
                    eventSink?.success(
                        hashMapOf<String?, Any?>(
                            "event_type" to cameraMotionEvent.eventName,
                            "event_data" to """${cameraMotionEvent.faceRect.left}
                                |,${cameraMotionEvent.faceRect.top},
                                | ${cameraMotionEvent.faceRect.right},
                                |  ${cameraMotionEvent.faceRect.bottom}""".trimMargin()
                        )
                    )
                }
                is FaceNotCenteredEvent -> {
                    eventSink?.success(
                        hashMapOf<String?, Any?>(
                            "event_type" to cameraMotionEvent.eventName,
                            "event_data" to """""".trimMargin()
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

    class FlutterSurfaceProvider(
            private val surfaceTextureEntry: TextureRegistry.SurfaceTextureEntry,
            private val executor: Executor
    ) : Preview.SurfaceProvider {

        override fun onSurfaceRequested(request: SurfaceRequest) {
            val surfaceTexture = surfaceTextureEntry.surfaceTexture()
            surfaceTexture.setDefaultBufferSize(640, 480)
            request.provideSurface(Surface(surfaceTexture), executor, {})
        }
    }
}