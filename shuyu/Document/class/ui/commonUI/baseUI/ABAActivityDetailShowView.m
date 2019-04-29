//
//  ABAActivityDetailShowView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/12/17.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABAActivityDetailShowView.h"
#import "ABAHtmlActionObjc.h"

@interface ABAActivityDetailShowView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@end
@implementation ABAActivityDetailShowView
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(nonnull id)delegate{
    //进行配置控制器
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    //实例化对象
    configuration.userContentController = [WKUserContentController new];
    configuration.selectionGranularity = WKSelectionGranularityCharacter;
    //调用JS方法
    [ABAHtmlActionObjc addScriptMessageHandlerWithId:self withWKWebViewConfiguration:configuration.userContentController];
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    if (self = [super initWithFrame:frame configuration:configuration]) {
        //IOS12要先设置代理
//        if (@available(iOS 12.0, *)){
//            NSString *baseAgent = [self valueForKey:@"applicationNameForUserAgent"];
//            if (![baseAgent containsString:@"/LP.mayi.org"]) {
//                NSString *userAgent = [baseAgent stringByAppendingString:@"/LP.mayi.org"];
//                [self setValue:userAgent forKey:@"applicationNameForUserAgent"];
//            }
//        }
//        JYWeakify(self);
//        [self evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
//            NSString *userAgent = result;
//            NSString *newUserAgent = [userAgent stringByAppendingString:@"/LP.mayi.org"];
//
//            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"user-agent", nil];
//            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            //设置代理
//            [weakSelf setCustomUserAgent:newUserAgent];
//
//            weakSelf.allowsBackForwardNavigationGestures = YES;
//            weakSelf.UIDelegate = self;
//            weakSelf.navigationDelegate = self;
//        }];

        self.scrollView.bounces = NO;
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self sizeToFit];
    }
    return self;
}
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
-(void)setHtmlPath:(NSString *)htmlPath{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * hpath = [[NSBundle mainBundle] pathForResource:htmlPath
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:hpath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    
    [self loadHTMLString:htmlCont baseURL:baseURL];
}

- (void)setHtml:(NSString *)html{
    _html = html;
    [self loadHTMLString:_html baseURL:nil];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [[WDLUsefulKitModel getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [ABAHtmlActionObjc receiveMessageFromH5OperationWithData:message.body withMethorName:message.name withWebview:self withCompleteBlock:nil];
}
- (void)dealloc{
    NSLog(@"webview已经销毁");
}
@end
