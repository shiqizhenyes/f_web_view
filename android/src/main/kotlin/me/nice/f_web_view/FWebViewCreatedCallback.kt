package me.nice.f_web_view

import android.content.Context

interface FWebViewCreatedCallback {
    fun onCreate(context: Context?, viewId: Int, fWebView: FWebView, args: Any?)
}