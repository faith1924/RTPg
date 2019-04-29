//
//  AppDelegate.m
//  ColorGame
//
//  Created by cyg on 15/12/31.
//  Copyright © 2015年 cyg. All rights reserved.
//

#import "AppDelegate.h"
#import "XHLaunchAd.h"
#import <UMCommon/UMCommon.h>
#import <AVOSCloud/AVOSCloud.h>
#import "LeanCloudInterface.h"
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "JYCommonObjc.h"
#import "XHLaunchAd.h"
#import "CGAppKey.h"


@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self JYConfAdView];
    [self CGConfigureThirdSDK];
    [self CGConfigurationPushInfoWithLaunchOptions:launchOptions];
    [self CGConfigurationLeanCloud:nil];
    [self infoConf];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)JYConfAdView{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    [XHLaunchAd setWaitDataDuration:3];
    //配置广告数据
    XHLaunchImageAdConfiguration * imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    imageAdconfiguration.imageNameOrURLString = @"bgImage.jpg";
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

/**
 第三方登录、分享
 */
- (void)CGConfigureThirdSDK{
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:UMSocialAppKey channel:@"App Store"];
}

/**
 推荐方法, 统一在AppKey.h中配置key
 
 @param launchOptions App launchOptions
 */
- (void)CGConfigurationPushInfoWithLaunchOptions:(NSDictionary *)launchOptions{
    
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
 配置云服务器leanCloud
 */
- (void)CGConfigurationLeanCloud:(void (^)(BOOL))success{
    [AVOSCloud setApplicationId:LeanCloudID clientKey:LeanCloudKey];
    [AVOSCloud setAllLogsEnabled:YES];
    [LeanCloudInterface userLoginName:[JYCommonObjc getUserName] password:[JYCommonObjc getUserName] result:^(BOOL status) {
        NSLog(@"登录成功");
    }];
#ifdef DEBUG
    
#else
#endif
}
//获取后台配置参数 微信 支付宝 打开url链接 是否显示网页
- (void)infoConf{
    [LeanCloudInterface getClassInfo:@"userInfo" keyDic:@[@"name",@"userid",@"sex",@"age",@"desc"] result:^(BOOL status,id object) {
        [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"userLoginStatus"];
        [LeanCloudResModel shareCloudModel].clientUserInfo = object;
        [LeanCloudInterface updataObjectID:[LeanCloudResModel shareCloudModel].userid];
        NSLog(@"%@",object);
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
    return YES;
}
#pragma clang diagnostic pop


@end
