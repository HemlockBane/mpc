package com.teamapt.customers.moniepoint.lib.camera

import android.view.Surface
import androidx.camera.core.Preview
import androidx.camera.core.SurfaceRequest
import io.flutter.view.TextureRegistry.SurfaceTextureEntry
import java.util.concurrent.Executor

class FlutterSurfaceProvider(
        private val surfaceTextureEntry: SurfaceTextureEntry,
        private val executor: Executor
) : Preview.SurfaceProvider {

    override fun onSurfaceRequested(request: SurfaceRequest) {
        val surfaceTexture = surfaceTextureEntry.surfaceTexture()
//        Size(1280, 720)
        surfaceTexture.setDefaultBufferSize(720, 1280)
        request.provideSurface(Surface(surfaceTexture), executor, {})
    }
}