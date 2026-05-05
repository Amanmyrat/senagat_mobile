package com.aplinxy9plin.senagat

import android.content.Context
import android.content.SharedPreferences
import android.view.WindowManager
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    private val SECURE_SCREEN_CHANNEL = "secure_screen"
    private val SECURE_STORAGE_CHANNEL = "senagat_secure_storage"

    private val securePrefs: SharedPreferences by lazy {
        val masterKey = MasterKey.Builder(this)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        EncryptedSharedPreferences.create(
            this,
            "senagat_secure_storage",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURE_SCREEN_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enable" -> {
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE
                    )
                    result.success(null)
                }

                "disable" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURE_STORAGE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "write" -> {
                    val key = call.argument<String>("key")
                    val value = call.argument<String>("value")

                    if (key.isNullOrEmpty() || value == null) {
                        result.error("INVALID_ARGUMENT", "Key or value is missing", null)
                        return@setMethodCallHandler
                    }

                    securePrefs.edit()
                        .putString(key, value)
                        .apply()

                    result.success(null)
                }

                "read" -> {
                    val key = call.argument<String>("key")

                    if (key.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "Key is missing", null)
                        return@setMethodCallHandler
                    }

                    result.success(securePrefs.getString(key, null))
                }

                "deleteAll" -> {
                    securePrefs.edit().clear().apply()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}