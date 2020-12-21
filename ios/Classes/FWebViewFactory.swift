//
//  FWebViewFactory.swift
//  f_web_view
//
//  Created by zack on 2020/12/19.
//

protocol FWebViewCreatedDelegate {
    func onCreate(viewId: Int64, view: FWebView)
}

class FWebViewFactory: NSObject, FlutterPlatformViewFactory {
    
    var fWebView: FWebView?
    var delegate: FWebViewCreatedDelegate?
    
    init(delegate: FWebViewCreatedDelegate) {
        self.delegate = delegate
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        fWebView = FWebView()
        if (self.delegate != nil) {
            self.delegate?.onCreate(viewId: viewId, view: self.fWebView!)
        }
        return fWebView!
    }
    
}
