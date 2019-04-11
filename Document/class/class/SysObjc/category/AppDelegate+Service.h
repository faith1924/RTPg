//
//  AppDelegate+Service.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/3.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "AppDelegate.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (Service)<JPUSHRegisterDelegate>
/**
 推荐方法, 统一在AppKey.h中配置key
 
 @param launchOptions App launchOptions
 */
- (void)JYConfigurationPushInfoWithLaunchOptions:(NSDictionary *)launchOptions;

/**
 第三方登录、分享
 
 */
- (void)JYConfigureThirdSDK;

/**
 配置云服务器leanCloud
 */
- (void)JYConfigurationLeanCloud:(void(^)(BOOL complete))success;

@end

NS_ASSUME_NONNULL_END
