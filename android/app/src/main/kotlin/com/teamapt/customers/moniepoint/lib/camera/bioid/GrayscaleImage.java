package com.teamapt.customers.moniepoint.lib.camera.bioid;


import androidx.annotation.NonNull;

/**
 * Class representing the grayscale part of a YUV_420_888 image.
 */
public class GrayscaleImage {

    @NonNull
    public final byte[] data;
    public final int width;
    public final int height;

    GrayscaleImage(@NonNull byte[] data, int width, int height) {
        this.data = data;
        this.width = width;
        this.height = height;
    }
}