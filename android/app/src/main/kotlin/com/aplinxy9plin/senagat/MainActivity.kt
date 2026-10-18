package com.aplinxy9plin.senagat

import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.ContentUris
import android.content.ContentValues
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.view.WindowManager
import androidx.core.content.FileProvider
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : FlutterFragmentActivity() {

    private val SECURE_SCREEN_CHANNEL = "secure_screen"
    private val SECURE_STORAGE_CHANNEL = "senagat_secure_storage"
    private val DOWNLOADS_CHANNEL = "senagat_downloads"

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

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            DOWNLOADS_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "savePdf" -> {
                    val name = call.argument<String>("name")
                    val bytes = call.argument<ByteArray>("bytes")
                    if (name.isNullOrEmpty() || bytes == null) {
                        result.error("INVALID_ARGUMENT", "Name or bytes are missing", null)
                        return@setMethodCallHandler
                    }
                    try {
                        result.success(savePdfToDownloads(name, bytes))
                    } catch (error: Exception) {
                        result.error("SAVE_FAILED", error.message, null)
                    }
                }

                "findPdf" -> {
                    val name = call.argument<String>("name")
                    if (name.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "Name is missing", null)
                        return@setMethodCallHandler
                    }
                    result.success(findPdf(name))
                }

                "hasPdf" -> {
                    val location = call.argument<String>("location")
                    result.success(!location.isNullOrEmpty() && hasPdf(location))
                }

                "openPdf" -> {
                    val location = call.argument<String>("location")
                    if (location.isNullOrEmpty()) {
                        result.error("INVALID_ARGUMENT", "Location is missing", null)
                        return@setMethodCallHandler
                    }
                    try {
                        openPdf(location)
                        result.success(null)
                    } catch (error: ActivityNotFoundException) {
                        result.error("NO_APP", error.message, null)
                    } catch (error: Exception) {
                        result.error("OPEN_FAILED", error.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun savePdfToDownloads(name: String, bytes: ByteArray): String {
        val fileName = if (name.endsWith(".pdf")) name else "$name.pdf"
        val privateFile = invoiceFile(fileName)
        privateFile.writeBytes(bytes)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val uri = contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IOException("Could not create the download")
            contentResolver.openOutputStream(uri)?.use { stream ->
                stream.write(bytes)
            } ?: throw IOException("Could not write the download")
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            contentResolver.update(uri, values, null, null)
        } else {
            val directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            if (!directory.exists() && !directory.mkdirs()) {
                throw IOException("Could not open Downloads")
            }
            File(directory, fileName).writeBytes(bytes)
        }
        return privateFile.absolutePath
    }

    private fun invoiceFile(name: String): File {
        val directory = File(filesDir, "invoices")
        if (!directory.exists() && !directory.mkdirs()) {
            throw IOException("Could not store the invoice")
        }
        return File(directory, name)
    }

    private fun findPdf(name: String): String? {
        val privateFile = File(File(filesDir, "invoices"), name)
        if (privateFile.exists() && privateFile.length() > 0L) {
            return privateFile.absolutePath
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val projection = arrayOf(MediaStore.Downloads._ID)
            contentResolver.query(
                MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                projection,
                "${MediaStore.Downloads.DISPLAY_NAME}=?",
                arrayOf(name),
                "${MediaStore.Downloads.DATE_ADDED} DESC"
            )?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val id = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Downloads._ID))
                    return ContentUris.withAppendedId(
                        MediaStore.Downloads.EXTERNAL_CONTENT_URI,
                        id
                    ).toString()
                }
            }
            return null
        }
        val publicFile = File(
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
            name
        )
        return if (publicFile.exists()) publicFile.absolutePath else null
    }

    private fun hasPdf(location: String): Boolean {
        if (location.startsWith("content://")) {
            return try {
                contentResolver.openFileDescriptor(Uri.parse(location), "r")?.use { true } ?: false
            } catch (_: Exception) {
                false
            }
        }
        return File(location).exists()
    }

    private fun openPdf(location: String) {
        val uri = if (location.startsWith("content://")) {
            Uri.parse(location)
        } else {
            val file = File(location)
            if (!file.exists()) throw IOException("Missing invoice")
            FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
        }
        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/pdf")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            clipData = ClipData.newRawUri("invoice", uri)
        }
        startActivity(intent)
    }
}