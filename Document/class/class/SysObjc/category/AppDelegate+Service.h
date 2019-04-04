//
//  AppDelegate+Service.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/3.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Service)
/**
 推荐方法, 统一在AppKey.h中配置key
 
 @param launchOptions App launchOptions
 */
- (void)JYConfigurationPushInfoWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 第三方登录、分享
 
 */
- (void)JYConfigureThirdSDK;


@end

NS_ASSUME_NONNULL_END
