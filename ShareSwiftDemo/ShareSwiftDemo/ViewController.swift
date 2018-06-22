//
//  ViewController.swift
//  ShareSwiftDemo
//
//  Created by Miaoz on 2018/6/7.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var textField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        textField.center = CGPoint(x: view.center.x, y: view.center.y - 260)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.placeholder = ""
        textField.delegate = self
        textField.text = "www/index.html"//https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html
        self.view.addSubview(textField)
        
        
        let btn = UIButton(type: .system)
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.borderWidth = 1.0
        btn.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        btn.center = CGPoint(x: view.center.x, y: view.center.y - 190)
        btn.setTitle("启动贷款SDK(local)", for: .normal)
        btn.addTarget(self, action: #selector(launchClick), for: .touchUpInside)
        self.view.addSubview(btn)
        //设置用户自定义的平台
        self.shareManageConfig()
    }

    @objc func launchClick() {
        var str = "www/index.html"
        if textField.text != nil &&  !(textField.text?.isEmpty)!{
            str = textField.text!
        }
        //        str = "https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html?t=test"
        let helper = QHLoanDoor.share().setDataInfo([:])?.setBasicDelegate(self)?.setBarColor("#d8e6ff")?.setBarTitleColor("#000000")?.setBarTitleFontSize(17)?.setBackBtnTitle("返回")?.setBackBtnTitleColor("#ff6600")?.setBackBtnImage(nil)?.setAgent("ToCred")?.setCoreWebView(QHCoreWebViewEnum.uiWebView)?.setStartPageUrl(str)?.start()!
    }
    
    func shareManageConfig() {
        UMShareSwiftInterface.setPreDefinePlatforms([
            NSNumber(integerLiteral: UMSocialPlatformType.wechatSession.rawValue),
            NSNumber(integerLiteral: UMSocialPlatformType.wechatTimeLine.rawValue),
             NSNumber(integerLiteral: UMSocialPlatformType.wechatFavorite.rawValue)])
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runShare(type:UMSocialPlatformType,shareInfo:NSDictionary) {
        let webpageObject = UMShareWebpageObject.init()
        let  paramData:NSDictionary = shareInfo["paramData"] as! NSDictionary
        webpageObject.title = paramData["shareTitle"] as! String
        webpageObject.descr = paramData["shareContent"] as! String
        webpageObject.thumbImage = paramData["shareImageUrl"] as! String
        webpageObject.webpageUrl = paramData["shareActionUrl"] as! String
        let messageObject = UMSocialMessageObject.init()
        messageObject.shareObject = webpageObject
        UMShareSwiftInterface.share(plattype: type, messageObject: messageObject, viewController: self) { (result, error) in
            //do anything
        }
    }
    
   func showBottomNormalView(shareInfo:NSDictionary)
    {
//    //加入copy的操作
//    //@see http://dev.umeng.com/social/ios/进阶文档#6
//    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+2
//    withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
//    withPlatformName:@"演示icon"];
    
        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType.bottom;
        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType.none;
        UMShareSwiftInterface.showShareMenuViewInWindowWithPlatformSelectionBlock { (platformType, userInfo) in
            //判断是否安装分享的app
            if  UMSocialManager.default().isInstall(platformType) {
                 self.runShare(type: platformType, shareInfo: shareInfo)
            } else {
                //没有安装分享所需的app,提示
            }
           
        }
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
      
        if info["action"] as! String == "gotoShare" {
            //分享的类型
            let shareType = info["shareType"] as? String
            //如果shareType有值直接分享
            if (shareType != nil) && !(shareType?.isEmpty)! {
                let platformType =  UMSocialPlatformType.init(rawValue: Int(shareType!)!)
                //判断是否安装分享的app
                if  UMSocialManager.default().isInstall(platformType!) {
                    self.runShare(type: platformType!, shareInfo: info! as NSDictionary)
                } else {
                    //没有安装分享所需的app,提示
                }
            } else {
                 //如果shareType没值则需要弹出选择面板
                 self.showBottomNormalView(shareInfo: info! as NSDictionary)
            }
        }
        return [:]
    }
    
    
}

extension ViewController:UMSocialShareMenuViewDelegate {
    func umSocialShareMenuViewDidAppear() {
        print("UMSocialShareMenuViewDidAppear")
    }
    
    func umSocialShareMenuViewDidDisappear() {
         print("UMSocialShareMenuViewDidDisappear")
    }
     //不需要改变父窗口则不需要重写此协议
    func umSocialParentView(_ defaultSuperView: UIView?) -> UIView? {
        
        return defaultSuperView
    }
}

extension ViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

