package com.example.ex01_dagger.dagger

import com.example.ex01_dagger.car.Engine
import com.example.ex01_dagger.car.PatrolEngine
import dagger.Binds
import dagger.Module

@Module
abstract class PatrolEngineModule {

    @Binds
    abstract fun bindEngine(patrolEngine: PatrolEngine): Engine

}