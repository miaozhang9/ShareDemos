//
//  AppDelegate.swift
//  ShareDemo
//
//  Created by Miaoz on 2018/6/6.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.configShare()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result: Bool = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result {
        }
        return result
    }


    /// 分享模块初始化
    func configShare(){
        //打开Log
        UMConfigure.setLogEnabled(true)
        //注册UM
        UMConfigure.initWithAppkey("5aa0a339f43e481c8c000132", channel: "Enterprise Edition")
        
        //注册wechat
        //好友
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wxbee4ca7417c3c312", appSecret: "5be46e300a9eaa0edd89d9bd16a2ea89", redirectURL: "http://www.24money.com")
        //朋友圈
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: "wxbee4ca7417c3c312", appSecret: "5be46e300a9eaa0edd89d9bd16a2ea89", redirectURL: "http://www.24money.com")
    }
}

