package com.example.ex01_dagger.car

import android.util.Log
import javax.inject.Inject

class DiselEngine constructor(var horsePower: Int) : Engine {
    val TAG = "Car"

    override fun start() {
        Log.d(TAG, "DiselEngine started. HorsePower : $horsePower")
    }
}