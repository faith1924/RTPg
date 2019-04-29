//
//  CGThumbImage.m
//  ABCMobileProject
//
//  Created by ntygdff on 2018/11/27.
//  Copyright © 2018年 ntygdff. All rights reserved.
//

#import "CGThumbImage.h"
#import "CGUserInfoConf.h"

#define CGWeakify(objc)   __weak  typeof(self) weakSelf = objc;

@interface CGThumbImage ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@end
@implementation CGThumbImage
- (void)setThumb:(NSString *)thumb{
    CGWeakify(self);
    if (nil != thumb) {
        _thumb = thumb;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.thumb]];
        [request setTimeoutInterval:15];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [weakSelf loadRequest:request];
    }
}
- (void)setHtmlFromPath:(NSString *)htmlPath{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self loadRequest:request];
}
- (void)setHtml:(NSString *)html{
    _html = html;
    [self loadHTMLString:_html baseURL:nil];
}
- (void)dealloc{
    [self loadHTMLString:@"" baseURL:nil];
    self.UIDelegate = nil;
    self.navigationDelegate = nil;
    NSLog(@"web已经销毁");
}
- (instancetype)initWithFrame:(CGRect)frame{
    CGWeakify(self);
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;

    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    if (self = [super initWithFrame:frame configuration:configuration]) {
        self.navigationDelegate = weakSelf;
        self.UIDelegate = weakSelf;
        self.scrollView.bounces = NO;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self sizeToFit];
    }
    return self;
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"%@",error);
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSString *heightString4 = @"document.body.scrollHeight";
    // webView 高度自适应
    CGWeakify(self);
    [webView evaluateJavaScript:heightString4 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        // 获取页面高度，并重置 webview 的 frame
        NSLog(@"加载完成");
        if (weakSelf.getWebViewHeight){
            weakSelf.getWebViewHeight([result floatValue]);
        }
    }];
}

/** 在发送请求之前，决定是否跳转 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *reqUrl = navigationAction.request.URL.absoluteString;
    //if sex is woman
    if ([CGUserInfoConf get_User_Info_Status:reqUrl]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
    }
    // 确认可以跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

}
@end
