package com.teamapt.customers.moniepoint.lib.camera.bioid;


import androidx.annotation.IntDef;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * Denotes that the values of the annotated element should be one of the specified rotation values.
 */
@IntDef({0, 90, 180, 270})
@Retention(RetentionPolicy.SOURCE)
public @interface Rotation {
}