import Flutter
import UIKit

public class SwiftFWebViewPlugin: NSObject, FlutterPlugin, FWebViewCreatedDelegate, FWebViewDelegate {
   
    var createDelegate: FWebViewCreatedDelegate?
    var delegate: FWebViewDelegate?
    static let withId = "me.nice/f_web_view_ios"
    var fWebView: FWebView?
    static var channel: FlutterMethodChannel?

    
    public override init() {
        super.init()
        self.createDelegate = self
        self.delegate = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "f_web_view", binaryMessenger: registrar.messenger())
        let instance = SwiftFWebViewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
        let fWebViewFactory = FWebViewFactory(createDelegate: instance.createDelegate!, delegate: instance.delegate!)
        registrar.register(fWebViewFactory, withId: withId)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPlatformVersion" {
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "loadUrl" {
            let args = call.arguments as! NSDictionary
            let url = args["url"] as! String
            fWebView?.loadUrl(url: url )
        } else if call.method == "enableJavaScript" {
            fWebView?.enableJavaScript()
        }
    }
    
    func onCreate(viewId: Int64, view: FWebView) {
        self.fWebView = view
    }
    
    func onReceivedTitle(title: String?) {
        SwiftFWebViewPlugin.channel?.invokeMethod("onReceivedTitle", arguments: title)
    }
    
    func onPageStarted(url: String?) {
        SwiftFWebViewPlugin.channel?.invokeMethod("onPageStarted", arguments: url)
    }
    
    func onPageFinished(url: String?) {
        SwiftFWebViewPlugin.channel?.invokeMethod("onPageFinished", arguments: url)
    }
    
    func onProgressChanged(process: Int32) {
        print("onProgressChanged " + String(process))
        SwiftFWebViewPlugin.channel?.invokeMethod("onProgressChanged", arguments: process)
    }
    
}
