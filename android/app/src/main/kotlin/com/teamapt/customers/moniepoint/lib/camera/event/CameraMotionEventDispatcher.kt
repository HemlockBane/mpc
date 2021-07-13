package com.teamapt.customers.moniepoint.lib.camera.event

/**
 * @author Paul Okeke
 */
class CameraMotionEventDispatcher {

    private val handlers = hashMapOf<Class<out CameraMotionEvent>, CameraMotionEventHandler<out CameraMotionEvent>>()

    fun <E: CameraMotionEvent> registerHandler(klass: Class<out E>, handler: CameraMotionEventHandler<E>) {
        handlers[klass] = handler
    }

    @Suppress("UNCHECKED_CAST")
    fun <E: CameraMotionEvent> dispatch(event : E) {
        println("Debugging for ${event.javaClass.name}")
        val handler = handlers[event.javaClass] as CameraMotionEventHandler<E>?
        handler?.onEvent(event)
    }

}