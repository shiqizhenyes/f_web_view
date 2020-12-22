package me.nice.f_web_view

import android.content.Context
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FWebViewFactory(createArgsCodec: MessageCodec<Any>?,
                      private val createCallback: FWebViewCreatedCallback,
                      private val callback: FWebViewCallback
) :
        PlatformViewFactory(createArgsCodec) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val fWebView = FWebView(context, callback, viewId)
        createCallback.onCreate(context, viewId, fWebView, args)
        return fWebView
    }

}