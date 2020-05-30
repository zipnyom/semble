package com.example.ex01_dagger.car

import android.util.Log
import javax.inject.Inject


class Car {
    val TAG = "Car"

    @Inject
    lateinit var engine: Engine
    @Inject
    lateinit var wheels: Wheels

    @Inject
    constructor()

    @Inject
    fun enableRemote() {
        val remote = Remote()
        remote.setListner(this)
    }

    fun drive() {
        engine.start()
        Log.d(TAG, "driving...")
    }
}