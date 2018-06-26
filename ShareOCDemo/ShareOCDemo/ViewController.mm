//
//  ViewController.m
//  ShareOCDemo
//
//  Created by Miaoz on 2018/6/6.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "ViewController.h"
#import <QHLoanlib/QHLoanlib.h>
#import "UIWebViewVC.h"
#import "WKWebViewVC.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>





@interface ViewController ()<UITextFieldDelegate,UMSocialShareMenuViewDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.textField];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1.0;
    btn.frame = CGRectMake(0, 0, 300, 50);
    btn.center = CGPointMake(self.view.center.x, self.view.center.y - 130);
    [btn setTitle:@"启动贷款SDK(local)" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(launch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.layer.borderColor = [UIColor blueColor].CGColor;
    btn2.layer.borderWidth = 1.0;
    btn2.frame = CGRectMake(0, 0, 300, 50);
    btn2.center = CGPointMake(self.view.center.x, self.view.center.y - 130 + 100);
    [btn2 setTitle:@"启动UIWebViewVC" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(launchUIWebViewVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *bt3 = [UIButton buttonWithType:UIButtonTypeSystem];
    bt3.layer.borderColor = [UIColor blueColor].CGColor;
    bt3.layer.borderWidth = 1.0;
    bt3.frame = CGRectMake(0, 0, 300, 50);
    bt3.center = CGPointMake(self.view.center.x, self.view.center.y - 130 + 200);
    [bt3 setTitle:@"启动WKWebViewVC" forState:UIControlStateNormal];
    [bt3 addTarget:self action:@selector(launchWKWebViewVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt3];
}

- (void)launch{
    NSString *str = @"www/index.html";
    if (self.textField.text != nil && self.textField.text.length > 0) {
        str = self.textField.text;
    }

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

- (void)launchUIWebViewVC{
    NSString *str = @"www/index.html";
    if (self.textField.text != nil && self.textField.text.length > 0) {
//        str = self.textField.text;
    }
    UIWebViewVC *vc = [[UIWebViewVC alloc] init];
    vc.startUrlStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)launchWKWebViewVC{
    NSString *str = @"www/index.html";
    if (self.textField.text != nil && self.textField.text.length > 0) {
//        str = self.textField.text;
    }
    WKWebViewVC *vc = [[WKWebViewVC alloc] init];
    vc.startUrlStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
        _textField.center = CGPointMake(self.view.center.x, self.view.center.y -200);
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.placeholder = @"请输入网址";
        _textField.text = @"https://loanapp-mam-stg2.pingan.com.cn:10271/app/website/ylbsat/index.html#/sharePage?mediaSource=ylb";//@"www/index.html";
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

    [self getDataInfo:info];
    return {};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
