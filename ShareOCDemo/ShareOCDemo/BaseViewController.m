//
//  BaseViewController.m
//  ShareOCDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "BaseViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface BaseViewController ()<UMSocialShareMenuViewDelegate>

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置用户自定义的平台
    [self shareManageConfig];

}



-(void)dealloc {
     [UMSocialUIManager setShareMenuViewDelegate:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDataInfo:(NSDictionary *)info{
    
    if ([info[@"action"] isEqualToString:@"gotoShare"]) {
        
        NSString *shareType = info[@"shareType"];
        //如果shareType有值直接分享
        if (shareType && shareType.length > 0) {
            NSInteger platformType = shareType.integerValue;
            //判断是否安装分享的app
            if ([[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType)platformType]) {
                [self runShareWithType:(UMSocialPlatformType)platformType withShareInfo:info];
            } else {
                //没有安装分享所需的app,提示
            }
            
        } else {
            //如果shareType没值则需要弹出选择面板
            [self showBottomNormalView:info];
        }
        
    }
}

- (void)shareManageConfig{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatFavorite),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_Tim),
                                               @(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_TencentWb),
                                               @(UMSocialPlatformType_AlipaySession),
                                               @(UMSocialPlatformType_DingDing),
                                               @(UMSocialPlatformType_Renren),
                                               @(UMSocialPlatformType_Douban),
                                               @(UMSocialPlatformType_Sms),
                                               @(UMSocialPlatformType_Email),
                                               @(UMSocialPlatformType_Facebook),
                                               @(UMSocialPlatformType_FaceBookMessenger),
                                               @(UMSocialPlatformType_Twitter),
                                               @(UMSocialPlatformType_LaiWangSession),
                                               @(UMSocialPlatformType_LaiWangTimeLine),
                                               @(UMSocialPlatformType_YixinSession),
                                               @(UMSocialPlatformType_YixinTimeLine),
                                               @(UMSocialPlatformType_YixinFavorite),
                                               @(UMSocialPlatformType_Instagram),
                                               @(UMSocialPlatformType_Line),
                                               @(UMSocialPlatformType_Whatsapp),
                                               @(UMSocialPlatformType_Linkedin),
                                               @(UMSocialPlatformType_Flickr),
                                               @(UMSocialPlatformType_KakaoTalk),
                                               @(UMSocialPlatformType_Pinterest),
                                               @(UMSocialPlatformType_Tumblr),
                                               @(UMSocialPlatformType_YouDaoNote),
                                               @(UMSocialPlatformType_EverNote),
                                               @(UMSocialPlatformType_GooglePlus),
                                               @(UMSocialPlatformType_Pocket),
                                               @(UMSocialPlatformType_DropBox),
                                               @(UMSocialPlatformType_VKontakte),
                                               @(UMSocialPlatformType_UserDefine_Begin+1),
                                               ]];
    //#endif
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
}


- (void)showBottomNormalView:(NSDictionary *)shareInfo
{
    //加入copy的操作
    //@see http://dev.umeng.com/social/ios/进阶文档#6
    
    //    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1
    //                                     withPlatformIcon:[UIImage imageNamed:@"icon_circle"]
    //                                     withPlatformName:@"演示icon"];
    
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //判断是否安装了分享的app
        if ([[UMSocialManager defaultManager] isInstall:(UMSocialPlatformType)platformType]) {
            [self runShareWithType:platformType withShareInfo:shareInfo];
        } else {
            //没有安装分享所需的app,提示
        }
        
    }];
}

- (void)runShareWithType:(UMSocialPlatformType)type withShareInfo:(NSDictionary *)shareInfo
{
    UMShareWebpageObject *webpageObject =  [[UMShareWebpageObject alloc] init];
    NSDictionary *paramData = shareInfo[@"paramData"];
    webpageObject.title = paramData[@"shareTitle"];
    webpageObject.descr = paramData[@"shareContent"];
    webpageObject.thumbImage = paramData[@"shareImageUrl"];
    webpageObject.webpageUrl =  paramData[@"shareActionUrl"];
    //@"https://loanapp-stg.pingan.com.cn/app/website/ylbsat/index.html#/sharePage?mediaSource=ylb";//
    UMSocialMessageObject *messageObject = [[UMSocialMessageObject alloc] init];
    messageObject.shareObject = webpageObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        //do anything
    }];
    
    
}

#pragma mark - UMSocialShareMenuViewDelegate
- (void)UMSocialShareMenuViewDidAppear
{
    NSLog(@"UMSocialShareMenuViewDidAppear");
}
- (void)UMSocialShareMenuViewDidDisappear
{
    NSLog(@"UMSocialShareMenuViewDidDisappear");
}

//不需要改变父窗口则不需要重写此协议
- (UIView*)UMSocialParentView:(UIView*)defaultSuperView
{
    return defaultSuperView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
