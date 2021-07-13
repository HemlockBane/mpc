package com.teamapt.customers.moniepoint.lib.camera

data class CameraDescription(
        // Should be one of the CameraMetaData.
         val cameraName: String,
         val lensFacing: Int,
         val sensorOrientation: Int
)