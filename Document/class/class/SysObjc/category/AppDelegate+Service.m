//
//  AppDelegate+Service.m
//  RTPg
//
//  Created by atts on 2019/4/3.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "AppDelegate+Service.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import <AVOSCloud/AVOSCloud.h>
#import "LeanCloudInterface.h"

@implementation AppDelegate (Service)
/**
 推荐方法, 统一在AppKey.h中配置key
 
 @param launchOptions App launchOptions
 */
- (void)JYConfigurationPushInfoWithLaunchOptions:(NSDictionary *)launchOptions{

    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {

    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}
/**
 第三方登录、分享
 
 */
- (void)JYConfigureThirdSDK{
    
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    
//    [UMConfigure setLogEnabled:YES];//设置打开日志
    
    [UMConfigure initWithAppkey:UMSocialAppKey channel:@"App Store"];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatAppKey appSecret:WechatAppSecret redirectURL:WeChatRedirectURL];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppKey appSecret:nil redirectURL:QQRedirectURL];

    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

/**
 配置云服务器leanCloud
 */
- (void)JYConfigurationLeanCloud:(void (^)(BOOL))success{
    [AVOSCloud setApplicationId:LeanCloudID clientKey:LeanCloudKey];

#ifdef DEBUG
//    [AVOSCloud setAllLogsEnabled:YES];
#else
#endif
    [LeanCloudInterface getClassInfo:@"profile" complete:^(BOOL status) {
        JYLog(@"\n获取后台状态：%@\n",(status?@"success":@"failure"));
        success(status);
    }];
}

#pragma mark UIApplication delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#pragma clang diagnostic pop

@end
