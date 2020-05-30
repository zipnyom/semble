package com.example.ex01_dagger.car

import android.util.Log
import com.example.ex01_dagger.car.Car
import javax.inject.Inject

class Remote {

    val TAG = "Car"

    @Inject
    constructor()

    fun setListner(car: Car) {
        Log.d(TAG, "Remote connected")
    }

}