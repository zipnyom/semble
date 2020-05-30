package com.example.ex01_dagger.dagger

import com.example.ex01_dagger.car.DiselEngine
import com.example.ex01_dagger.car.Engine
import dagger.Module
import dagger.Provides

@Module
class DiselEngineModule(var horsePower: Int) {

    @Provides
    fun provideHorsePower(): Int {
        return horsePower
    }

    @Provides
    fun provideEngine(diselEngine: DiselEngine): Engine {
        return diselEngine
    }

}