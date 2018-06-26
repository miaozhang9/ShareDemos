//
//  WKWebViewVC.swift
//  ShareSwiftDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import Foundation
import WebKit

class WKWebViewVC: BaseViewController {
    var startUrlStr:String?
    var webview:WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        var url:URL?
        if self.startUrlStr == "www/index.html" {
            url = URL.init(fileURLWithPath: Bundle.main.path(forResource: "index.html", ofType: nil)!)
            //            fileURL(withPath:Bundle.main.path(forResource: "index.html", ofType: nil)!) as NSURL
        } else {
            url = URL(string: ((self.startUrlStr != nil) && (self.startUrlStr?.count)! > 0 ? self.startUrlStr:nil)!)
        }
        
        let config = WKWebViewConfiguration.init()
        config.preferences.minimumFontSize = 18
        let webview = WKWebView(frame: UIScreen.main.applicationFrame, configuration: config)
        webview.uiDelegate = self as WKUIDelegate;
        webview.navigationDelegate = self as WKNavigationDelegate;
        let request = URLRequest.init(url: url!)
        webview.load(request)
        self.webview = webview
        self.view.addSubview(webview)
        let conntentController = webview.configuration.userContentController
        //show 是JS中对应的方法名
        conntentController.add(self as WKScriptMessageHandler, name: "executeH5InfoAction")
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //记得移除通知
        let conntentController = self.webview?.configuration.userContentController
        conntentController?.removeScriptMessageHandler(forName: "executeH5InfoAction")
    }
}

extension WKWebViewVC: WKScriptMessageHandler{
    
    //WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "executeH5InfoAction" {
            self.getDataInfo(info: message.body as! NSDictionary)
        }
    }
}
extension WKWebViewVC: WKUIDelegate{
    
}


extension WKWebViewVC: WKNavigationDelegate{
    
}
