package com.example.ex01_dagger.car

import com.example.ex01_dagger.car.Rims
import com.example.ex01_dagger.car.Tires
import javax.inject.Inject

class Wheels {
    @Inject
    constructor(rims: Rims, tires: Tires) {
    }
}