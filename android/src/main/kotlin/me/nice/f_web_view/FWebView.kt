package me.nice.f_web_view

import android.content.Context
import android.view.View
import android.webkit.WebView
import io.flutter.plugin.platform.PlatformView


open class FWebView(context: Context?, id: Int): PlatformView {

    private var webView: WebView ?= WebView(context)
    
    init {
        webView?.id = id
    }
    
    override fun getView(): WebView? = webView

    override fun dispose() {
        webView?.destroy()
        webView = null
    }

    fun loadUrl(url: String?) {
        webView?.loadUrl(url)
    }

    fun enableJavaScript() {
        true.also { webView?.settings?.javaScriptEnabled = it }
    }

//    protected fun () {
//        webView.
//    }



}