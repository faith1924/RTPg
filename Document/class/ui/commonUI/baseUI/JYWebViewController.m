//
//  JYWebViewController.m
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYWebViewController.h"
#import "ABAActivityDetailShowView.h"
#import "ABAHtmlActionObjc.h"

@interface JYWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (strong , nonatomic) ABAActivityDetailShowView * webView;

@end

@implementation JYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.webView = [[ABAActivityDetailShowView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, JYScreenW, JYScreenH - SafeAreaTopHeight) withDelegate:self];
    //KVO监听
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    self.webView.urlString = self.urlString;
    [self.view addSubview:self.webView];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"title"]){
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}
- (void)dealloc{
    NSLog(@"页面控制器销毁成功");
    [_webView removeObserver:self forKeyPath:@"title" context:nil];
    [ABAHtmlActionObjc removeScriptMessageHandlerWithWKWebViewConfiguration:_webView.configuration.userContentController];
    _webView.navigationDelegate = nil;
    _webView.UIDelegate = nil;
    
    [_webView loadHTMLString:@"" baseURL:nil];
    [_webView stopLoading];
    [_webView removeFromSuperview];
    _webView = nil;
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
