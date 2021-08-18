package com.connexxion.wemoove

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.androidalarmmanager.AlarmService
import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin

import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin

class Application() : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {

    override fun registerWith(registry: PluginRegistry?) {
        /*AlarmService.setPluginRegistrant(this)*/
        val key: String? = FlutterFirebaseMessagingPlugin::class.java.canonicalName
        if (!registry?.hasPlugin(key)!!) {
            FlutterFirebaseMessagingPlugin.registerWith(registry?.registrarFor("io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin"));
        }

       /* AndroidAlarmManagerPlugin.registerWith(
                registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"))*/

    }
}