package com.teamapt.customers.moniepoint.lib.camera.event

/**
 * @author Paul Okeke
 * 
 * This is a/an handler for handling motion and camera specific events detected
 * The implementing class should provide concrete implementation of onEvent
 */
interface CameraMotionEventHandler<T : CameraEvent> {
    fun onEvent(event: T)
}