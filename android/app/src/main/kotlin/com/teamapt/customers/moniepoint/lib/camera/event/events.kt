package com.teamapt.customers.moniepoint.lib.camera.event

import android.graphics.Bitmap
import android.media.FaceDetector
import android.media.Image
import java.io.File

sealed class CameraMotionEvent(val eventName: String? = "") : CameraEvent

object CameraInitializedEvent : CameraMotionEvent()

object CameraDisconnectedEvent: CameraMotionEvent()

object CameraInitializationErrorEvent: CameraMotionEvent()

data class FirstCaptureEvent(val bitmap: File?) : CameraMotionEvent("FirstCaptureEvent")
data class FaceDetectedEvent(val bitmap: File?) : CameraMotionEvent("FaceDetectedEvent")
data class MotionDetectedEvent(val bitmap: File?) : CameraMotionEvent("MotionDetectedEvent")
data class NoFaceDetectedEvent(val bitmap: File?) : CameraMotionEvent("NoFaceDetectedEvent")
data class NoMotionDetectedEvent(val bitmap: File?) : CameraMotionEvent("NoMotionDetectedEvent")

object FaceOutOfBoundsEvent : CameraMotionEvent("FaceOutOfBoundsEvent")

data class CameraSessionConfigurationFailed(val message: String = "Failed to configure camera session"): CameraMotionEvent()

data class ImageStreamAvailable (val image: Image) : CameraMotionEvent()
