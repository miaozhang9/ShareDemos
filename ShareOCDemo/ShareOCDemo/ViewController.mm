//
//  ViewController.m
//  ShareOCDemo
//
//  Created by Miaoz on 2018/6/6.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "ViewController.h"
#import <QHLoanlib/QHLoanlib.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>


@interface ViewController ()<UITextFieldDelegate,UMSocialShareMenuViewDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self shareManageConfig];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.frame = CGRectMake(0, 0, 300, 50);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y - 190);
    [btn setTitle:@"启动贷款SDK(local)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)launch{
    //抽出给Native 用
   
    //    @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/ajd/index.html?t=list"
    NSString *str = @"www/index.html";
    if (self.textField.text != nil && self.textField.text.length > 0) {
        str = self.textField.text;
    }
    //    str = @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html";"
    //    str = @"http://p2pp-loan-stg2.pingan.com.cn:12080/loan/page/ajd/index.html?t=sdk";
    //    str = @"http://yujiangshui.github.io/test-webview/";
    //    str = @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/ajd/index.html?t=list";
    //    str = @"https://test-p2pp-loan-stg.pingan.com.cn/loan/page/demo/index.html?t=test";
    [QHLoanDoor share].setDataInfo(@{}).setBasicDelegate(self).setBarColor(@"#d8e6ff").setBarTitleColor(@"#000000").setBarTitleFontSize(17).setBackBtnTitle(@"返回").setBackBtnTitleColor(@"#ff6600").setBackBtnImage(nil).setAgent(@"ToCred").setCoreWebView(QHCoreWebView_UIWebView).setStartPageUrl(str).start();//
    //        .callBackBlcok = ^(BOOL isSuccess, NSError *error){   // 1
    //
    //            if (isSuccess) {
    //                NSLog(@"isSuccess");
    //            } else {
    //                NSLog(@"NOisSuccess");
    //            }
    //
    //        };
    
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _textField.center = CGPointMake(self.view.center.x, self.view.center.y -260);
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"请输入网址";
        _textField.text = @"www/index.html";
        _textField.delegate = self;
    }
    return _textField;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
//}
#pragma mark -QHBasicProtocol
//得到用户账户信息
-(NSDictionary *)getAgentUserInfo {
    
    return{};
}
//跳转new的h5Page
-(BOOL)openNewPageWithUrl:(NSString *)url{
    
    return true;
}
//打开调起登录
-(void)openLaunchLoginPage{
    
}
//跳转new的Page params传递参数
-(void)openNewPageWithParams:(NSDictionary *)params{
    
}
//得到H5信息操作 多功能接口 可以返回信息给H5
-(NSDictionary *)executeH5InfoAction:(NSDictionary *)info{
    
    //    [[QHLoanDoor share] interfaceOrientation:UIInterfaceOrientationPortrait];
    
    //    [[QHLoanDoor share] sendCallBackPluginResultDictionary:@{@"sssss":@"dddddd"} resultStatus:YES];
   
    if ([info[@"action"] isEqualToString:@"gotoShare"]) {
        [self showBottomNormalView:info];
    }
  
    return {};
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
            
             [self runShareWithType:platformType withShareInfo:shareInfo];
            
        }];
    }

- (void)runShareWithType:(UMSocialPlatformType)type withShareInfo:(NSDictionary *)shareInfo
{
    UMShareWebpageObject *webpageObject =  [[UMShareWebpageObject alloc] init];
    NSDictionary *paramData = shareInfo[@"paramData"];
    webpageObject.title = paramData[@"shareTitle"];
    webpageObject.descr = paramData[@"shareContent"];
    webpageObject.thumbImage = paramData[@"shareImageUrl"];//@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528437962549&di=6dc8710b0e286c919e4b611c3ca40cb3&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F016b815809fab8a84a0d304f7e1fde.png";//
    webpageObject.webpageUrl =  paramData[@"shareActionUrl"];//@"https://loanapp-stg.pingan.com.cn/app/website/ylbsat/index.html#/activityPage?mediaSource=ylb&refereePhone=18321509093";//
    UMSocialMessageObject *messageObject = [[UMSocialMessageObject alloc] init];
    messageObject.shareObject = webpageObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        //do anything
    }];
   
   ;
  
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
