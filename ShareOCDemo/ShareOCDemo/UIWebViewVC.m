//
//  UIWebViewVC.m
//  ShareOCDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "UIWebViewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface UIWebViewVC ()<UIWebViewDelegate>
@property (nonatomic, strong) JSContext *jsContext;
@end

@implementation UIWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIWebViewVC";
    NSURL *url = nil;
    if ([self.startUrlStr isEqualToString:@"www/index.html"]) {
        url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil]];
    }
    else{
        url = [NSURL URLWithString:self.startUrlStr && self.startUrlStr.length > 0 ? self.startUrlStr: nil];
    }
    
    CGRect bouds = [[UIScreen mainScreen] applicationFrame];
    UIWebView* webView = [[UIWebView alloc]initWithFrame:bouds];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [webView loadRequest:request];//加载

}


#pragma mark --UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.jsContext = (JSContext *)[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        NSLog(@"%@", exception);
        con.exception = exception;
    };
   
    __weak __typeof(self) weakSelf = self;
    // @"executeH5InfoAction"为和js 约定执行的方法名,这样js 可以自由选择时机调用native端 OC 代码
      self.jsContext[@"executeH5InfoAction"] = ^(id info) {
          __strong __typeof(self) strongSelf = weakSelf;
          //回调js 传递的参数 和上边info一样
//        NSArray *args = [JSContext currentArguments];
          dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf getDataInfo:(NSDictionary *)info];
        });
    };
    

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
