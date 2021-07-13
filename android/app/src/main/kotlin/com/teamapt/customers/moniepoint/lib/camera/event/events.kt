package com.teamapt.customers.moniepoint.lib.camera.event

import android.graphics.Bitmap
import android.media.FaceDetector
import android.media.Image

sealed class CameraMotionEvent : CameraEvent

object CameraInitializedEvent : CameraMotionEvent()

object CameraDisconnectedEvent: CameraMotionEvent()

object CameraInitializationErrorEvent: CameraMotionEvent()

data class FaceDetectedEvent(val bitmap: Bitmap?) : CameraMotionEvent()
data class MotionDetectedEvent(val bitmap: Bitmap?) : CameraMotionEvent()

object CameraFaceOutOfBoundsEvent : CameraMotionEvent()

data class CameraSessionConfigurationFailed(val message: String = "Failed to configure camera session"): CameraMotionEvent()

data class ImageStreamAvailable (val image: Image) : CameraMotionEvent()