//
//  JYWebViewController.m
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYWebViewController.h"
#import "ABAActivityDetailShowView.h"
#import "ABAHtmlActionObjc.h"
#import "ABAPopShareCategoryView.h"

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

@interface JYWebViewController ()<UIWebViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (strong , nonatomic) ABAActivityDetailShowView * webView;

@end

@implementation JYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[ABAActivityDetailShowView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, JYScreenH - SafeAreaTopHeight) withDelegate:self];
    //KVO监听
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    if(![self.urlString isEqualToString:@""] && self.urlString != nil){
        
        self.webView.urlString = self.urlString;
        
    }else if (![_htmlPath isEqualToString:@""] && _htmlPath != nil){
        
        self.webView.htmlPath= _htmlPath;
        
    }
    [self addSubview:self.webView];
    
    if (_isCanShare == YES) {
        UIBarButtonItem *shareBtn= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"subscription_article_detail_more"] style:UIBarButtonItemStyleDone target:self action:@selector(shareArticle)];
        self.navigationItem.rightBarButtonItems = @[shareBtn];
    }
    
#if (isManager==0)
    
#else
    self.view.backgroundColor = tabBgColor;
    self.hbd_barHidden = NO;
    self.hbd_barTintColor = tabBgColor;
    self.hbd_tintColor = kWhiteColor;
    self.webView.backgroundColor = cellBgColor;
    self.webView.tintColor = RGBA(255.0f, 255.0f, 255.0f, 0.4);
    
    UIImage* itemImage= [UIImage imageNamed:@"back_btn_white"]; // Colored Image
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithImage:itemImage style:UIBarButtonItemStyleDone target:self action:@selector(popself)];
    self.navigationItem.leftBarButtonItem=leftBtn;
#endif

}
- (void)popself{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark event
- (void)shareArticle{
    NSMutableDictionary * shareDic = [NSMutableDictionary new];
    PARAMS(shareDic, @"shareThumbnail", self.shareThumbnail);
    PARAMS(shareDic, @"shareUrl", self.urlString);
    PARAMS(shareDic, @"shareTitle", self.shareTitle);
    PARAMS(shareDic, @"shareBrief", self.shareBrief);
    
    [[ABAPopShareCategoryView shareView] initWithShareConfDic:shareDic withShareType:2 withShareArr:[NSMutableArray arrayWithObjects:@"微信好友",@"朋友圈",@"复制链接",nil]];
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
