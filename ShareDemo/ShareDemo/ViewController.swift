//
//  ViewController.swift
//  ShareDemo
//
//  Created by Miaoz on 2018/6/6.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var shareInfo: NSDictionary?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        textField.center = CGPoint(x: view.center.x, y: view.center.y - 260)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入网址"
        textField.text = "https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html"
        self.view.addSubview(textField)
        
        
        let btn = UIButton(type: .system)
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.borderWidth = 1.0
        btn.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        btn.center = CGPoint(x: view.center.x, y: view.center.y - 190)
        btn.setTitle("启动贷款SDK(local)", for: .normal)
        btn.addTarget(self, action: #selector(launchClick), for: .touchUpInside)
        self.view.addSubview(btn)
        

    }
    
    @objc func launchClick() {
        var str = "www/index.html"
        
//        str = "https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html?t=test"
        let helper = QHLoanDoor.share().setDataInfo([:])?.setBasicDelegate(self)?.setBarColor("#d8e6ff")?.setBarTitleColor("#000000")?.setBarTitleFontSize(17)?.setBackBtnTitle("返回")?.setBackBtnTitleColor("#ff6600")?.setBackBtnImage(nil)?.setAgent("ToCred")?.setCoreWebView(QHCoreWebViewEnum.uiWebView)?.setStartPageUrl(str)?.start()!

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

extension ViewController: QHBasicProtocol{
    func getAgentUserInfo() -> [AnyHashable : Any]! {
        return [:]
    }
    
    func openNewPage(withUrl url: String!) -> Bool {
         return true
    }
    
    func openLaunchLoginPage() {
        
    }
    
    func openNewPage(withParams params: [AnyHashable : Any]!) {
      
    }
    
    func executeH5InfoAction(_ info: [AnyHashable : Any]!) -> [AnyHashable : Any]! {
        if  !YLBShareInterface.isInstall(plattype: .wechatSession) {
//            ToastCenter.default().postToast(withMessage: "您尚未安装微信，请安装后重试")
            return [:]
        }
// {'action':'gotoShare','paramData':{'shareTitle':'标题','shareContent':'内容内容','shareImageUrl':'图片url','shareActionUrl':'https://www.jianshu.com/u/2c2ace30f4f1'}}
        
        
        print("\(info)")
        self.shareInfo = NSDictionary.init(dictionary: info)
        if info["action"] as! String == "gotoShare" {
            let shareMangerAttribute = YLBShareManagerAttribute.defaultShareManagerAttribute()
            let loanShareManager = YLBShareManager.init(frame: UIScreen.main.bounds, attribute: shareMangerAttribute, delegate: self)
            loanShareManager.show(toView: nil)
        }

        return [:]
    }
    

}

extension ViewController: YLBShareManagerProtocol {
    
    func touchItem(itemMessage: YLBShareMessage) {
        switch itemMessage.platformType {
        case .wechatSession,.wechatTimeLine:
            //分享到微信
            let shareObject = YLBShareObject.init()
            if (self.shareInfo?["paramData"] != nil) {
                let  paramData:NSDictionary = self.shareInfo?["paramData"] as! NSDictionary
                shareObject.title = paramData["shareTitle"]  as! String
                shareObject.descr = paramData["shareContent"] as! String
                shareObject.thumbImage = paramData["shareImageUrl"]  as! String
                shareObject.webpageUrl = paramData["shareActionUrl"]  as! String
                itemMessage.shareObject = shareObject
                
                YLBShareInterface.share(plattype: itemMessage.platformType, messageObject: itemMessage, viewController: self, completion: { (data, error) in
                    // do anything
                })
            }else {
                 print("数据错误")
            }
        default:
           print("失败")
        }
    }
}
