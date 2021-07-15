package com.teamapt.customers.moniepoint.lib.camera.event

import android.graphics.Bitmap
import android.media.FaceDetector
import android.media.Image
import java.io.File

sealed class CameraMotionEvent(val eventName: String? = "") : CameraEvent

object CameraInitializedEvent : CameraMotionEvent()

object CameraDisconnectedEvent: CameraMotionEvent()

object CameraInitializationErrorEvent: CameraMotionEvent()

data class FaceDetectedEvent(val bitmap: File?) : CameraMotionEvent("FaceDetectedEvent")
data class MotionDetectedEvent(val bitmap: File?) : CameraMotionEvent("MotionDetectedEvent")
data class NoFaceDetectedEvent(val bitmap: File?) : CameraMotionEvent("NoFaceDetectedEvent")
data class NoMotionDetected(val bitmap: File?) : CameraMotionEvent("NoMotionDetected")

object CameraFaceOutOfBoundsEvent : CameraMotionEvent()

data class CameraSessionConfigurationFailed(val message: String = "Failed to configure camera session"): CameraMotionEvent()

data class ImageStreamAvailable (val image: Image) : CameraMotionEvent()
