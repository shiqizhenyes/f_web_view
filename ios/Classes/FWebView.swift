//
//  FWebView.swift
//  f_web_view
//
//  Created by zack on 2020/12/19.
//

import Foundation
import WebKit

class FWebView: NSObject, FlutterPlatformView, WKUIDelegate, WKNavigationDelegate {

    var webViewConfiguration: WKWebViewConfiguration!
    var webView: WKWebView!
    var delegate: FWebViewDelegate?
    
    
    init(delegate: FWebViewDelegate?) {
        super.init()
        self.delegate = delegate
    }
    
    func view() -> UIView {
        webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.preferences.javaScriptEnabled = false
        webViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = false
        webView = WKWebView(frame: .zero, configuration: self.webViewConfiguration!)
        webView.uiDelegate = self
        webView.navigationDelegate = self
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
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !((navigationAction.targetFrame?.isMainFrame) != nil) {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.delegate?.onPageStarted(url: webView.url?.absoluteString)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("didFailProvisionalNavigation")
        print(error)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.delegate?.onReceivedTitle(title: webView.title)
        if webView.isLoading {
            print("isLoading" + webView.title!)
            self.delegate?
                .onProgressChanged(process: Int32(webView.estimatedProgress * 100))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.delegate?.onProgressChanged(process: 100)
        self.delegate?.onReceivedTitle(title: webView.title)
        self.delegate?.onPageFinished(url: webView.url?.absoluteString)
    }
    
}
