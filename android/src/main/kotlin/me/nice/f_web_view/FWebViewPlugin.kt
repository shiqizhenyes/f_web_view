package me.nice.f_web_view

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FWebViewPlugin */
class FWebViewPlugin : FlutterPlugin, MethodCallHandler, FWebViewCallback {

    private val tag = FWebViewPlugin::class.simpleName

    private lateinit var channel: MethodChannel
    private val channelName: String = "f_web_view"
    private val viewTypeId: String = "me.nice/f_web_view_android"
    private var fWebView: FWebView? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(tag, "onAttachedToEngine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName)
        channel.setMethodCallHandler(this@FWebViewPlugin)
        val fWebViewFactory = FWebViewFactory(null, object : FWebViewCreatedCallback {
            override fun onCreate(context: Context?, viewId: Int, fWebView: FWebView, args: Any?) {
                this@FWebViewPlugin.fWebView = fWebView
                Log.d(tag, "FWebViewFactory onCreate")
            }
        }, this)
        flutterPluginBinding.platformViewRegistry.registerViewFactory(viewTypeId, fWebViewFactory)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(tag, "onMethodCall ${call.method}")
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "loadUrl" -> {
                fWebView?.loadUrl(call.argument<String>("url"))
            }
            "enableJavaScript" -> {
                fWebView?.enableJavaScript()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onReceivedTitle(title: String?) {
        channel.invokeMethod("onReceivedTitle", title)
    }

    override fun onPageStarted(url: String?) {
        channel.invokeMethod("onPageStarted", url)
    }

    override fun onPageFinished(url: String?) {
        channel.invokeMethod("onPageFinished", url)
    }

    override fun onProgressChanged(process: Int) {
        channel.invokeMethod("onProgressChanged", process)
    }
}
