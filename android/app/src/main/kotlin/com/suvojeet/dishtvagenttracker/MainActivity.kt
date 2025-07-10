package com.suvojeet.dishtvagenttracker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Environment
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.dishtv.agenttracker/pdf"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "savePdf") {
                val pdfBytes = call.argument<ByteArray>("pdfBytes")
                val fileName = call.argument<String>("fileName")
                if (pdfBytes != null && fileName != null) {
                    try {
                        val filePath = savePdfToDownloads(pdfBytes, fileName)
                        showDownloadNotification(fileName, filePath)
                        result.success("PDF saved to $filePath")
                    } catch (e: Exception) {
                        result.error("SAVE_FAILED", "Failed to save PDF.", e.toString())
                    }
                } else {
                    result.error("INVALID_ARGUMENTS", "Invalid arguments for savePdf", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun savePdfToDownloads(pdfBytes: ByteArray, fileName: String): String {
        val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val file = File(downloadsDir, fileName)
        FileOutputStream(file).use { it.write(pdfBytes) }
        return file.absolutePath
    }

    private fun showDownloadNotification(fileName: String, filePath: String) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "pdf_download_channel"

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "PDF Downloads", NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("Download Complete")
            .setContentText("$fileName has been saved to your Downloads folder.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .build()

        notificationManager.notify(1, notification)
    }
}
