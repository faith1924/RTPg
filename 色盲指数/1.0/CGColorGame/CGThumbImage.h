//
//  CGThumbImage.h
//  ABCMobileProject
//
//  Created by ntygdff on 2018/11/27.
//  Copyright © 2018年 ntygdff. All rights reserved.
//

#import "CGThumbImage.h"
#import "BaseWebView.h"
NS_ASSUME_NONNULL_BEGIN

@interface CGThumbImage : BaseWebView
@property (strong , nonatomic) NSString * htmlFromPath;
@property (strong , nonatomic) NSString * thumb;
@property (strong , nonatomic) NSString * htmlBody;
@property (strong , nonatomic) NSString * html;
@property (strong , nonatomic) void(^getWebViewHeight)(float height);
@property (strong , nonatomic) void(^htmlInteractiveComplete)(void);
@end

NS_ASSUME_NONNULL_END
