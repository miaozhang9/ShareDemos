//
//  WKWebViewVC.m
//  ShareOCDemo
//
//  Created by Miaoz on 2018/6/26.
//  Copyright © 2018年 Miaoz. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface WKWebViewVC ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic, strong)WKWebView *webView;
@end

@implementation WKWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WKWebViewVC";
    NSURL *url = nil;
    if ([self.startUrlStr isEqualToString:@"www/index.html"]) {
        url = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil]];
    }
    else{
        url = [NSURL URLWithString:self.startUrlStr && self.startUrlStr.length > 0 ? self.startUrlStr: nil];
    }
    
    CGRect bouds = [[UIScreen mainScreen] applicationFrame];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:bouds configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:request];
    _webView = webView;
    [self.view addSubview:webView];
    
    //window.webkit.messageHandlers.<事件名>.postMessage(需要传递的数据)
    WKUserContentController *conntentController = webView.configuration.userContentController;
    [conntentController addScriptMessageHandler:self name:@"executeH5InfoAction"];
}

#pragma mark --WKNavigationDelegate
//判断链接是否允许跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
   
     WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

//拿到响应后决定是否允许跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//}

//链接开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//收到服务器重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//加载错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

//当内容开始到达主帧时被调用（即将完成）
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
}

//在提交的主帧中发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
}

//当webView需要响应身份验证时调用(如需验证服务器证书)
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//    
//}

//当webView的web内容进程被终止时调用。(iOS 9.0之后)
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark --WKUIDelegate
//接收到警告面板
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

//接收到确认面板
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
}

//接收到输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler{
    
}

#pragma mark --WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //message.name 为 ScriptMessage 的名称
    if ([message.name isEqualToString:@"executeH5InfoAction"]) {
        //做处理 do something
        //message.body 为此 ScriptMessage 传递的消息内容
        [self getDataInfo:(NSDictionary *)message.body];
    }
}

- (void)dealloc{
    
    WKUserContentController *conntentController = self.webView.configuration.userContentController;
    [conntentController removeScriptMessageHandlerForName:@"executeH5InfoAction"];
    
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
