//
//  YLBShareInterface.swift
//  YLBEE
//
//  Created by 郭阳阳(金融壹账通客户端研发团队) on 2018/3/22.
//  Copyright © 2018年 冯铁军. All rights reserved.
//

import Foundation

class YLBShareInterface: NSObject {
    
    ///平台是否安装
    static func isInstall(plattype:YLBSharePlatformType) -> Bool {
        var umPlatformType: UMSocialPlatformType = UMSocialPlatformType.unKnown
        switch plattype {
        case .wechatSession:
            umPlatformType = .wechatSession
        case .wechatFavorite:
            umPlatformType = .wechatFavorite
        case .wechatTimeLine:
            umPlatformType = .wechatTimeLine
        default:
            umPlatformType = .unKnown
        }
       return UMSocialManager.default().isInstall(umPlatformType)
    }

    
    
    //分享
    static func share(plattype:YLBSharePlatformType,
                      messageObject:YLBShareMessage,
                      viewController:UIViewController?,
                      completion: @escaping (_ data:Any?,_ error:Error?) -> Void) -> Void{
        
        var umPlatformType: UMSocialPlatformType = UMSocialPlatformType.unKnown
        switch plattype {
        case .wechatSession:
            umPlatformType = .wechatSession
        case .wechatFavorite:
            umPlatformType = .wechatFavorite
        case .wechatTimeLine:
            umPlatformType = .wechatTimeLine
        default:
            umPlatformType = .unKnown
        }
        UMSocialManager.default().share(to: umPlatformType, messageObject: messageObject, currentViewController: viewController) { (shareResponse, error) in
            completion(shareResponse, error);
        }
    }
    
 
}
