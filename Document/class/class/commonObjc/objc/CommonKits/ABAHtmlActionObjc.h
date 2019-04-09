//
//  ABAHtmlActionObjc.h
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/12/20.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface ABAHtmlActionObjc : NSObject
+ (void)receiveMessageFromH5OperationWithData:(NSString *)jsonString
                               withMethorName:(NSString *)methorName
                                  withWebview:(WKWebView *)webView
                            withCompleteBlock:(void(^)(void))complete;
+ (void)addScriptMessageHandlerWithId:(id)target withWKWebViewConfiguration:(WKUserContentController *)configuration;
+ (void)removeScriptMessageHandlerWithWKWebViewConfiguration:(WKUserContentController *)configuration;
@end
