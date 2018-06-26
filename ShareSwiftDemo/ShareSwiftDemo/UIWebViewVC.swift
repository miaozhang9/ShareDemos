//
//  UIWebViewVC.swift
//  ShareSwiftDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import Foundation
import JavaScriptCore

class UIWebViewVC: BaseViewController {
    var startUrlStr:String?
    var jsContext:JSContext?
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
        
        let webView = UIWebView(frame:  UIScreen.main.applicationFrame)
        webView.delegate = (self as! UIWebViewDelegate)
        self.view.addSubview(webView)

        let request = NSURLRequest(url: url! as URL)
        webView.loadRequest(request as URLRequest)
        
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


@objc protocol JavaScriptSwiftDelegate: JSExport {
    
    func executeH5InfoAction(_ info:NSDictionary)
    //注意：参数前面需要加 "_" 下划线
}
@objc class SwiftJavaScriptModel: NSObject, JavaScriptSwiftDelegate {
    
    weak var controller: BaseViewController?
    weak var jsContext: JSContext?
    
    func executeH5InfoAction(_ info:NSDictionary) {
        DispatchQueue.main.async(execute: {
                self.controller!.getDataInfo(info: info)
            })
    }
}

extension UIWebViewVC:UIWebViewDelegate {
    
   
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true
    }
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.jsContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        self.jsContext?.exceptionHandler = { con, exception in
            if let anException = exception {
                print("\(anException)")
            }
            if let anException = exception {
                con?.exception = anException
            }
        }
        
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = self.jsContext
        self.jsContext?.setObject(model, forKeyedSubscript: "Native" as NSCopying & NSObjectProtocol)
        //swift不能使用这种，只能使用model桥接
        // @"executeH5InfoAction"为和js 约定执行的方法名,这样js 可以自由选择时机调用native端 OC 代码
//        self.jsContext!["executeH5InfoAction"] = { [weak self] info in
//            DispatchQueue.main.async(execute: {
//                self.getDataInfo(info as? [AnyHashable: Any])
//            })
//        }


    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
    }
}

