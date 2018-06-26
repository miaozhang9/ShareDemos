//
//  BaseViewController.swift
//  ShareSwiftDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //设置用户自定义的平台
        self.shareManageConfig()
    }
    
   
   public func getDataInfo(info:NSDictionary) {
        if info["action"] as! String == "gotoShare" {
            //分享的类型
            let shareType = info["shareType"] as? String
            //如果shareType有值直接分享
            if (shareType != nil) && !(shareType?.isEmpty)! {
                let platformType =  UMSocialPlatformType.init(rawValue: Int(shareType!)!)
                //判断是否安装分享的app
                if  UMSocialManager.default().isInstall(platformType!) {
                    self.runShare(type: platformType!, shareInfo: info as NSDictionary)
                } else {
                    //没有安装分享所需的app,提示
                }
            } else {
                //如果shareType没值则需要弹出选择面板
                self.showBottomNormalView(shareInfo: info as NSDictionary)
            }
        }
    }
    
    func shareManageConfig() {
        UMShareSwiftInterface.setPreDefinePlatforms([
            NSNumber(integerLiteral: UMSocialPlatformType.wechatSession.rawValue),
            NSNumber(integerLiteral: UMSocialPlatformType.wechatTimeLine.rawValue),
            NSNumber(integerLiteral: UMSocialPlatformType.wechatFavorite.rawValue)])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         UMSocialUIManager.setShareMenuViewDelegate(nil) 
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


extension BaseViewController:UMSocialShareMenuViewDelegate {
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


