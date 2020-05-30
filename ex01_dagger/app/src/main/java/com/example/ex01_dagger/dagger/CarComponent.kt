package com.example.ex01_dagger.dagger

import android.os.Build
import com.example.ex01_dagger.MainActivity
import dagger.BindsInstance
import dagger.Component
import javax.inject.Named

@Component(modules = [WheelsModule::class, PatrolEngineModule::class])
interface CarComponæent {
    fun inject(mainActivity: MainActivity)


    @Component.Builder
    interface Builder {
        @BindsInstance
        fun horsePower(@Named("horse power")horsePower: Int): Builder

        @BindsInstance
        fun engineCapacity(@Named("engine capacity")engineCapacity: Int): Builder

        fun build(): CarComponæent
    }


}