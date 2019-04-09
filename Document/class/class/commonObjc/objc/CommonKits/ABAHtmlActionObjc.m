//
//  ABAHtmlActionObjc.m
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/12/20.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import "ABAHtmlActionObjc.h"
#import "ABAShareAlertView.h"
#import "JYCommonBaseWebView.h"

@interface ABAHtmlActionObjc ()<WKNavigationDelegate,WKUIDelegate>

@end
@implementation ABAHtmlActionObjc
+ (void)addScriptMessageHandlerWithId:(id)target withWKWebViewConfiguration:(WKUserContentController *)configuration{

}
+ (void)removeScriptMessageHandlerWithWKWebViewConfiguration:(WKUserContentController *)configuration{

}
/*h5交互*/
+ (void)receiveMessageFromH5OperationWithData:(NSString *)jsonString
                               withMethorName:(NSString *)methorName
                                  withWebview:(WKWebView *)webView
                            withCompleteBlock:(void(^)(void))complete{}
//保存图片
+ (void)saveImg:(NSString *)imageUrl{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
        }
    }];
}
@end
