package com.example.soundplayer

import android.content.res.AssetFileDescriptor
import android.media.SoundPool
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.InputStream


/** SoundplayerPlugin */
class SoundplayerPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var binding : FlutterPlugin.FlutterPluginBinding? = null
  private lateinit var pool: SoundPoolWrapper

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "soundplayer")
    channel.setMethodCallHandler(this)
    this.binding = flutterPluginBinding
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    print(call.method)
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      return
    }
    when (call.method) {
      "initSoundplayer" -> {
        var numStreams = call.argument<Int>("numStreams")
        pool = SoundPoolWrapper(numStreams = numStreams!!)
        pool.setAssetDir(binding!!)
      }
      "release" -> {
        pool.release()
      }
      else -> {
        pool.onMethodCall(call, result)
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    this.binding = null
  }
}

class SoundPoolWrapper(numStreams: Int) {
  private val numStreams = 1
  private val soundPool = SoundPool.Builder().setMaxStreams(numStreams).build()

  private fun createSoundPool() {
    return
  }

  private var assets: FlutterPlugin.FlutterAssets? = null
  private lateinit var binding: FlutterPluginBinding
  public fun setAssetDir(binding: FlutterPlugin.FlutterPluginBinding) {
    assets = binding.flutterAssets
    this.binding = binding
  }

  public fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {

      "load" -> {
        try {
          // Load Arguments
          val args = call.arguments as Map<String, Any>
          var path = args["path"] as String
          val path2: String = assets!!.getAssetFilePathByName(path!!)
          // Get Assets, then AssetFileDescriptor to load  with soundpool
          val allAssets = binding.applicationContext.assets
          val fd: AssetFileDescriptor = allAssets.openFd(path2)
          // Load
          val soundId = soundPool.load(fd, 1)
          result.success(soundId)
        } catch (t: Throwable) {
          result.error("Loading failure", t.message, null)
        }
      }
      "play" -> {
        // Get Arguments
        val args = call.arguments as Map<String, Any>
        var soundId = args["soundId"] as Int
        // play sound
        val streamId = soundPool.play(soundId, 1f, 1f, 1, 0, 1f)
        result.success(streamId)
      }
      "pause" -> {
        val args = call.arguments as Map<String, Any>
        var streamId = args["streamId"] as Int
        // play sound
        soundPool.pause(streamId)

      }
      "resume" -> {
        val args = call.arguments as Map<String, Any>
        var streamId = args["streamId"] as Int
        // play sound
        soundPool.resume(streamId)
      }
      "unload" -> {
        val args = call.arguments as Map<String, Any>
        var soundId = args["soundId"] as Int
        soundPool.unload(soundId)
      }
      "stop" -> {
        val args = call.arguments as Map<String, Any>
        var streamId = args["streamId"] as Int
        soundPool.stop(streamId)
      }

    }
  }

  public fun release() {
    soundPool.release()
  }

}

