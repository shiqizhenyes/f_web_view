package me.nice.f_web_view

import android.content.Context
import android.graphics.Bitmap
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.platform.PlatformView


open class FWebView(context: Context?, private val callback: FWebViewCallback, id: Int): PlatformView {

    private var webView: WebView ?= WebView(context)
    private var webViewClient: WebViewClient
    private var webChromeClient: WebChromeClient
    
    init {
        webView?.id = id
        webViewClient = object : WebViewClient() {
            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                callback.onPageStarted(url)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                callback.onPageFinished(url)
            }
        }
        webView?.webViewClient = webViewClient
        webChromeClient = object : WebChromeClient() {

            override fun onProgressChanged(view: WebView?, newProgress: Int) {
                super.onProgressChanged(view, newProgress)
                callback.onProgressChanged(newProgress)
            }

            override fun onReceivedIcon(view: WebView?, icon: Bitmap?) {
                super.onReceivedIcon(view, icon)
            }

            override fun onReceivedTitle(view: WebView?, title: String?) {
                super.onReceivedTitle(view, title)
                callback.onReceivedTitle(title)
            }

        }
        webView?.webChromeClient = webChromeClient
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
    
}