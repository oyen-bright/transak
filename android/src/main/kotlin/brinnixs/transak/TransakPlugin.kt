package brinnixs.transak

import android.app.Activity


import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding



/** TransakPlugin */
class TransakPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var eventChannel: EventChannel


 companion object {
        private var eventSink: EventChannel.EventSink? = null

        fun sendEvent(event: Any) {
            eventSink?.success(event)
        }
    }



  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "brinnixs/transak")
            eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "brinnixs/transak/events")

    channel.setMethodCallHandler(this)
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

  }

  override fun onDetachedFromActivity() {
      TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
      TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
      TODO("Not yet implemented")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "initiateTransaction" || call.method =="initiateTransactionStream" ) {
     BottomSheetWebView(call.arguments as HashMap<String, Any>, activity, result)
    } 
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}



