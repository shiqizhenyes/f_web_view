//
//  FWebViewFactory.swift
//  f_web_view
//
//  Created by zack on 2020/12/19.
//

protocol FWebViewCreatedDelegate {
    func onCreate(viewId: Int64, view: FWebView)
}

protocol FWebViewDelegate {
    func onReceivedTitle(title: String?)
    func onPageStarted(url: String?)
    func onPageFinished(url: String?)
    func onProgressChanged(process: Int32)
}

class FWebViewFactory: NSObject, FlutterPlatformViewFactory {
    
    var fWebView: FWebView?
    var createDelegate: FWebViewCreatedDelegate?
    var delegate: FWebViewDelegate?
    
    init(createDelegate: FWebViewCreatedDelegate, delegate: FWebViewDelegate) {
        self.createDelegate = createDelegate
        self.delegate = delegate
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        fWebView = FWebView(delegate: self.delegate)
        if (self.createDelegate != nil) {
            self.createDelegate?.onCreate(viewId: viewId, view: self.fWebView!)
        }
        return fWebView!
    }
    
}
