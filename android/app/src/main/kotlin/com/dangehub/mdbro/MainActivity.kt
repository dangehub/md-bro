package com.dangehub.mdbro

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val TAG = "MainActivity"
    private val INTENT_CHANNEL = "intent_handler"
    private var intentChannel: MethodChannel? = null
    private var pendingIntent: Intent? = null
    // Flag to ensure we only process the intent once
    private var intentHandled = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        intentChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL)
        intentChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialIntent" -> {
                    if (intentHandled) {
                        Log.d(TAG, "getInitialIntent called but intent already handled, returning null")
                        result.success(null)
                    } else {
                        val intentData = getIntentData(intent)
                        Log.d(TAG, "getInitialIntent called, data: $intentData")
                        intentHandled = true
                        result.success(intentData)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "onCreate, intent action: ${intent.getStringExtra("action")}")
        pendingIntent = intent
        intentHandled = false
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d(TAG, "onNewIntent, action: ${intent.getStringExtra("action")}")
        // Update the activity's intent so getIntent() returns the new one
        setIntent(intent)
        intentHandled = false
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val intentData = getIntentData(intent)
        Log.d(TAG, "handleIntent, data: $intentData")
        if (intentData != null) {
            intentChannel?.invokeMethod("onNewIntent", intentData)
        }
    }

    private fun getIntentData(intent: Intent?): Map<String, Any?>? {
        if (intent == null) return null
        
        val action = intent.getStringExtra("action")
        Log.d(TAG, "getIntentData, action: $action")
        if (action.isNullOrEmpty()) return null
        
        val extras = mutableMapOf<String, Any?>()
        intent.extras?.let { bundle ->
            for (key in bundle.keySet()) {
                extras[key] = bundle.get(key)
            }
        }
        
        return mapOf(
            "action" to action,
            "extras" to extras
        )
    }
}

