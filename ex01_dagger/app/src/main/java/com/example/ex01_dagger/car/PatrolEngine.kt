package com.example.ex01_dagger.car

import android.util.Log
import javax.inject.Inject
import javax.inject.Named

class PatrolEngine : Engine {

    val TAG = "Car"
    var horsePower: Int
    var engineCapcity: Int

    @Inject
    constructor(
        @Named("horse power") horsePower: Int,
        @Named("engine capacity") engineCapacity: Int
    ) {
        this.horsePower = horsePower
        this.engineCapcity = engineCapacity
    }

    override fun start() {
        Log.d(
            TAG, "PetrolEngine started." +
                    "\nhorsePower : $horsePower" +
                    "\nengineCapacity : $engineCapcity"
        )

    }
}