//
//  FWebView.swift
//  f_web_view
//
//  Created by zack on 2020/12/19.
//

import Foundation
import WebKit

class FWebView: NSObject, FlutterPlatformView {

    var webViewConfiguration: WKWebViewConfiguration!
    var webView: WKWebView!
    
    func view() -> UIView {
        webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = false
        webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webView = WKWebView(frame: .zero, configuration: self.webViewConfiguration!)
        return webView
    }
    
    func enableJavaScript() {
        webViewConfiguration.preferences.javaScriptEnabled = true
        webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
    }
    
    
    func loadUrl(url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        webView.load(urlRequest)
    }
    
}
