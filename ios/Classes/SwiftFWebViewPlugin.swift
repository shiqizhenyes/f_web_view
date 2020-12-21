import Flutter
import UIKit

public class SwiftFWebViewPlugin: NSObject, FlutterPlugin, FWebViewCreatedDelegate {

    var delegate: FWebViewCreatedDelegate?
    static let withId = "me.nice/f_web_view_ios"
    var fWebView: FWebView?
    
    
    public override init() {
        super.init()
        self.delegate = self
    }

    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "f_web_view", binaryMessenger: registrar.messenger())
        let instance = SwiftFWebViewPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let fWebViewFactory = FWebViewFactory(delegate: instance.delegate!)
        registrar.register(fWebViewFactory, withId: withId)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("zack call method " + call.method)
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
    
}
