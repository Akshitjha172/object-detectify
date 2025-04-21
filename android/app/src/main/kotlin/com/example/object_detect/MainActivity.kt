package com.example.object_detect

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.ImageFormat
import android.graphics.Rect
import android.graphics.YuvImage
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.objects.ObjectDetection
import com.google.mlkit.vision.objects.defaults.ObjectDetectorOptions
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "flickit.mlkit/object_detection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "detectObjects") {
                val imageData = call.arguments as Map<String, Any>
                val width = imageData["width"] as Int
                val height = imageData["height"] as Int
                val planes = imageData["planes"] as List<ByteArray>

                try {
                    val yuvImage = YuvImage(planes[0], ImageFormat.NV21, width, height, null)
                    val out = ByteArrayOutputStream()
                    yuvImage.compressToJpeg(Rect(0, 0, width, height), 100, out)
                    val imageBytes = out.toByteArray()
                    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

                    val inputImage = InputImage.fromBitmap(bitmap, 0)

                    val options = ObjectDetectorOptions.Builder()
                        .setDetectorMode(ObjectDetectorOptions.STREAM_MODE)
                        .enableMultipleObjects()
                        .enableClassification()
                        .build()

                    val objectDetector = ObjectDetection.getClient(options)

                    objectDetector.process(inputImage)
                        .addOnSuccessListener { detectedObjects ->
                            val results = detectedObjects.map { obj ->
                                mapOf(
  "left" to obj.boundingBox.left.toDouble() / width,
  "top" to obj.boundingBox.top.toDouble() / height,
  "width" to obj.boundingBox.width().toDouble() / width,
  "height" to obj.boundingBox.height().toDouble() / height,
  "label" to (obj.labels.firstOrNull()?.text ?: "Unknown"),
  "confidence" to (obj.labels.firstOrNull()?.confidence ?: 1.0f).toDouble()
)

                            }
                            result.success(results)
                        }
                        .addOnFailureListener { e ->
                            result.error("MLKitError", e.message, null)
                        }
                } catch (e: Exception) {
                    result.error("ProcessingError", e.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
