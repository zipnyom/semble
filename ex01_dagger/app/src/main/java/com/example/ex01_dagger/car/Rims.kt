package com.example.ex01_dagger.car

import android.util.Log
import javax.inject.Inject


class Rims {
    val TAG = "Car"
    constructor()
    fun ready() {
        Log.d(TAG, "rims are ready")
    }
}