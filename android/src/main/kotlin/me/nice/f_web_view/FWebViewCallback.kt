package me.nice.f_web_view

interface FWebViewCallback {
    fun onReceivedTitle(title: String?)
    fun onPageStarted(url: String?)
    fun onPageFinished(url: String?)
    fun onProgressChanged(process: Int)
}