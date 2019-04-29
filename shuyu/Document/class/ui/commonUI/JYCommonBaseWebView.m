//
//  JYCommonBaseWebView.m
//  ABCMobileProject
//
//  Created by mylm on 2018/11/27.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "JYCommonBaseWebView.h"

#import "ABAHtmlActionObjc.h"

@interface JYCommonBaseWebView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@end
@implementation JYCommonBaseWebView
- (void)setUrlString:(NSString *)urlString{
    JYWeakify(self);
    if (nil != urlString) {
        _urlString = urlString;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
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
- (void)setHtmlBody:(NSString *)htmlBody{
    if ([htmlBody isKindOfClass:[NSString class]]&&![htmlBody isEqualToString:@""]) {
        _htmlBody = htmlBody;
        
        NSMutableString * htmlString = [NSMutableString string];
        [htmlString appendString:@"<!DOCTYPE html>"];
        [htmlString appendString:@"<head lang=zh-cmn-Hans>"];
        [htmlString appendString:@"<meta http-equiv=\"Content-Type\" content=\"application/vnd.wap.xhtml+xml;charset=utf-8\"/>"];
        [htmlString appendString:@"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/>"];
        [htmlString appendString:@"<style type=\"text/css\">"];
        [htmlString appendString:@"</style>"];
        [htmlString appendString:@"</head>"];
        [htmlString appendString:@"<body>"];
        [htmlString appendString:_htmlBody];
        [htmlString appendString:@"</body>"];
        [htmlString appendString:@"</html>"];
        [self loadHTMLString:htmlString baseURL:nil];
    }
}
- (void)dealloc{
    [self loadHTMLString:@"" baseURL:nil];
    self.UIDelegate = nil;
    self.navigationDelegate = nil;
    NSLog(@"web已经销毁");
}
- (instancetype)initWithFrame:(CGRect)frame{
    JYWeakify(self);
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    
    //调用JS方法
    [ABAHtmlActionObjc addScriptMessageHandlerWithId:weakSelf withWKWebViewConfiguration:configuration.userContentController];

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
    JYWeakify(self);
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
    
    if ([reqUrl hasPrefix:[JYProfileObjc getAp]]  ||
        [reqUrl hasPrefix:[JYProfileObjc getAps]] ||
        [reqUrl hasPrefix:[JYProfileObjc getWp]])
    {

        BOOL bSucc = [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        // 如果跳转失败，则跳转itune下载支付宝Ap p
        if (!bSucc) {
            [MBProgressHUD showMessage:@"打开失败"];
        }
    }

    // 确认可以跳转
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    JYWeakify(self);
    [ABAHtmlActionObjc receiveMessageFromH5OperationWithData:message.body withMethorName:message.name withWebview:self withCompleteBlock:^{
        if (weakSelf.htmlInteractiveComplete) {
            weakSelf.htmlInteractiveComplete();
        }
    }];
}
@end
