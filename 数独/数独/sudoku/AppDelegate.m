//
//  AppDelegate.m
//  sudoku
//
//  Created by mac on 12-11-3.
//  Copyright (c) 2012年 com/ZH/mac. All rights reserved.
//

#import "AppDelegate.h"
#import "XHLaunchAd.h"
#import <UMCommon/UMCommon.h>
#import <AVOSCloud/AVOSCloud.h>
#import "JPUSHService.h"
#import "UBDataFace.h"
#import <UBSDK/UBSDK.h>
#import "AFNetworking.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AdSupport/AdSupport.h>


#define JPushKey      @"644de1c173e8d507c771ed5c"
#define JPushSecret   @"e44cfe5859455ffe3a1caea5"
#define UMSocialAppKey      @"5cc116883fc1955b03000cba"

#define LeanCloudID    @"zcGG7GPLlnmqCdRg3JKHD6Ex-gzGzoHsz"
#define LeanCloudKey  @"8jtsMcLod2tBAeD6Rn9KSAtQ"
#define LeanCloudMaseterKey  @"56PrO0zgG6KuvqnvPrEaTYnm"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    SDHomeVC * rootVC = [[SDHomeVC alloc]init];
    self.window.rootViewController = rootVC;
    
    [self confAdView];
    [self thirdSDK];
    [self ConfigurationPushInfoWithLaunchOptions:launchOptions];
    [self ConfLeanCloud:nil];
    [self ConfInfo];
    
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
- (void)playBackgroundMusic
{
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"bgMusic" ofType:@"MP3"];
    NSURL *url = [NSURL fileURLWithPath:pathString];
    [self.appMusicTool playSoundWithURL:url];
}

#pragma mark - getter
- (pbMusicTool *)appMusicTool
{
    if (!_appMusicTool) {
        
        _appMusicTool = [[pbMusicTool alloc]init];
        _appMusicTool.circulating = YES;
    }
    return _appMusicTool;
}

- (void)confAdView{
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    [XHLaunchAd setWaitDataDuration:3];
    //配置广告数据
    XHLaunchImageAdConfiguration * imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
    imageAdconfiguration.imageNameOrURLString = @"advertisement.png";
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

/**
 第三方登录、分享
 */
- (void)thirdSDK{
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure setLogEnabled:YES];//设置打开日志
    [UMConfigure initWithAppkey:UMSocialAppKey channel:@"App Store"];
}

/**
 推荐方法, 统一在AppKey.h中配置key
 
 @param launchOptions App launchOptions
 */
- (void)ConfigurationPushInfoWithLaunchOptions:(NSDictionary *)launchOptions{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    
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
- (void)ConfLeanCloud:(void (^)(BOOL))success{
    [AVOSCloud setApplicationId:LeanCloudID clientKey:LeanCloudKey];
    [AVOSCloud setAllLogsEnabled:YES];
}
//服务器端获取配置信息
- (void)ConfInfo{
    [self getNetStatus:^(BOOL status) {
        if(status){
            [UBDataFace getClassInfo:@"userInfo" keyDic:@[@"name",@"userid",@"sex",@"age",@"desc"] result:^(BOOL status,id object) {
                [UBDataObjc enCoderData:object];
            }];
        }
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
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *)) {
        if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    } else {
        // Fallback on earlier versions
    }
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}
- (void) getNetStatus:(void(^)(BOOL status))complete{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                //未知网络
                complete(NO);


            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                //无法联网
                complete(NO);

            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //手机自带网络
                complete(YES);

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //WIFI
                complete(YES);

            }
                
        }
    }];
}
@end
