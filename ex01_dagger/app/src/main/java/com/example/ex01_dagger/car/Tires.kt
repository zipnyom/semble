package com.example.ex01_dagger.car

import android.util.Log
import javax.inject.Inject

class Tires {
    val TAG = "Car"

    constructor()

    fun inflate() {
        Log.d(TAG, "Tires are inflated..")
    }
}
