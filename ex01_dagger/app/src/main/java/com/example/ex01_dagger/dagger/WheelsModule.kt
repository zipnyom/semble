package com.example.ex01_dagger.dagger

import com.example.ex01_dagger.car.Rims
import com.example.ex01_dagger.car.Tires
import com.example.ex01_dagger.car.Wheels
import dagger.Module
import dagger.Provides

@Module
class WheelsModule {

    @Provides
    fun provideRims(): Rims {
        return Rims();
    }

    @Provides
    fun provideTires(): Tires {
        var tires = Tires()
        tires.inflate()
        return tires
    }

    @Provides
    fun provideWheels(rims: Rims, tires: Tires): Wheels {
        return Wheels(rims, tires)
    }
}