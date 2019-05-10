//
//  AppDelegate.m
//  RTPg
//
//  Created by tts on 2019/4/2.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "AppDelegate.h"
#import "JYTabBarController.h"
#import "loginVC.h"

#import "ABASharePopView.h"


#if (isManager==1)

#import "Close_Db_Object.h"
#import "easyLoginVC.h"

#endif


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //初始化
    [[UINavigationBar appearance] setTintColor:kBlackColor];
    
    self.window.backgroundColor = kWhiteColor;
    [self.window makeKeyAndVisible];
    
    [self JYConfigurationPushInfoWithLaunchOptions:launchOptions];
    
    [self JYConfigureThirdSDK];
    
    //版本更新检测
    [ABASharePopView versionCheck:nil];
    
    //需要登录
#if (isManager==1)
    if ([Close_Db_Object Close_GetLoginStatus] == NO) {
        easyLoginVC * logVC = [easyLoginVC shareAasyLoginVC];
        UINavigationController * nv = [[UINavigationController alloc]initWithRootViewController:logVC];
        self.window.rootViewController = nv;
        
        JYWeakify(self);
        logVC.loginCom = ^(BOOL status) {
            if (status == YES) {
                [Close_Db_Object Close_SaveLoginStatus:YES];
                
                JYTabBarController * rootVC = [[JYTabBarController alloc]initWithTabbarType:defaultModel];
                weakSelf.window.rootViewController = rootVC;
            }
        };
    }else{
        JYTabBarController * rootVC = [[JYTabBarController alloc]initWithTabbarType:defaultModel];
        self.window.rootViewController = rootVC;
    }
#else
    JYTabBarController * rootVC = [[JYTabBarController alloc]initWithTabbarType:defaultModel];
    self.window.rootViewController = rootVC;
#endif

    //设置广告页
    [self JYConfAdView];
    
    [self JYConfigurationLeanCloud:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"RTPg"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end