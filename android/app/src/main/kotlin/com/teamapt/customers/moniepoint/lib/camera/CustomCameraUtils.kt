package com.teamapt.customers.moniepoint.lib.camera

import android.media.CamcorderProfile

class CustomCameraUtils {

    companion object {
        fun getBestAvailableCamcorderProfileForResolutionPreset(cameraName: String, preset: ResolutionPreset?): CamcorderProfile? {
            val cameraId = cameraName.toInt()
            return when {
                preset == ResolutionPreset.max && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_HIGH) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_HIGH)
                }
                preset == ResolutionPreset.ultraHigh && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_2160P) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_2160P)
                }
                preset == ResolutionPreset.veryHigh && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_1080P) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_1080P)
                }
                preset == ResolutionPreset.high && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_720P) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_720P)
                }
                preset == ResolutionPreset.medium && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_480P) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_480P)
                }
                preset == ResolutionPreset.low && CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_QVGA) -> {
                    return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_QVGA)
                }
                else -> if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_LOW)) {
                    CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_LOW)
                } else {
                    throw IllegalArgumentException("No capture session available for current capture session.")
                }
            }
        }
    }
}