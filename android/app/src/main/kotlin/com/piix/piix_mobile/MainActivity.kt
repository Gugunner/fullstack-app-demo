package com.piix.piix_mobile

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.piix.app/storage"
    private val writeExternalStorage : String = Manifest.permission.WRITE_EXTERNAL_STORAGE
    private val writeExternalStorageCode : Int = 22
    private val permissionGranted : String = "PERMISSION_GRANTED"
    private val permissionDenied : String = "PERMISSION_DENIED"
    private val getPermission : String = "GET_PERMISSION"
    private var pendingResult : MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStoragePermission" -> {
                    pendingResult = result
                    val permissionStatus = checkPermissionStatus(writeExternalStorage)
                    if (permissionStatus == getPermission) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE),
                                    writeExternalStorageCode)
                        }
                    }else{
                        result.success(permissionStatus)
                    }
                }
                "openAppSettings" -> openAppSettings()
                else -> result.notImplemented()
            }
        }
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when (requestCode) {
            writeExternalStorageCode -> {
                if ((grantResults.isNotEmpty() &&
                                grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
                    pendingResult?.success(permissionGranted)
                } else {
                    pendingResult?.success(permissionDenied)
                }
                return
            }
        }
    }

    private fun checkPermissionStatus(permission: String): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return when {
                ContextCompat.checkSelfPermission(
                        this,
                        permission
                ) == PackageManager.PERMISSION_GRANTED -> {
                    permissionGranted
                }
                shouldShowRequestPermissionRationale(permission) -> {
                    permissionDenied
                }
                else -> {
                    getPermission
                }
            }
        }
        return ""
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        val uri = Uri.fromParts("package", this.activity.packageName, null)
        intent.data = uri
        startActivity(intent)
    }
}