//
//  JYCommonBaseWebView.h
//  ABCMobileProject
//
//  Created by mylm on 2018/11/27.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "JYCommonBaseWebView.h"
#import "JYWebView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JYCommonBaseWebView : JYWebView
@property (strong , nonatomic) NSString * htmlFromPath;
@property (strong , nonatomic) NSString * urlString;
@property (strong , nonatomic) NSString * htmlBody;
@property (strong , nonatomic) NSString * html;
@property (strong , nonatomic) void(^getWebViewHeight)(float height);
@property (strong , nonatomic) void(^htmlInteractiveComplete)(void);
@end

NS_ASSUME_NONNULL_END
