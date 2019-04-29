//
//  CGUserInfoConf.m
//  CGColorGame
//
//  Created by md212 on 2019/4/19.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import "CGUserInfoConf.h"
#import "LeanCloudResModel.h"
#import "JYCommonObjc.h"
#import "LeanCloudInterface.h"

@interface CGUserInfoConf ()

@end
@implementation CGUserInfoConf

+ (NSString *)get_User_Info_Age{
    return [LeanCloudResModel shareCloudModel].age;
}
+ (BOOL)get_User_Info_Sex{
    return [LeanCloudResModel shareCloudModel].sex;
}
+ (NSString *)get_User_Info_Name{
    return [LeanCloudResModel shareCloudModel].name;
}
+ (NSString *)get_User_Info_Userid{
    return [LeanCloudResModel shareCloudModel].userid;
}
+ (NSString *)get_User_Info_Desc{
    return [LeanCloudResModel shareCloudModel].desc;
}
+ (BOOL)get_User_Info_Status:(NSString *)status{
    if ([status containsString:[self get_User_Info_Age]]) {
        return YES;
    }
    if ([status containsString:[self get_User_Info_Name]]) {
        return YES;
    }
    if ([status containsString:[self get_User_Info_Desc]]) {
        return YES;
    }
    return NO;
}

+ (UIViewController *)getKeyVC{
    UIViewController *vc = nil;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)window.rootViewController visibleViewController];
    }
    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController*)window.rootViewController;
        if ([[tabVC selectedViewController] isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)[tabVC selectedViewController] visibleViewController];
        }else if ([[tabVC selectedViewController] isKindOfClass:[UIViewController class]]){
            vc = [tabVC selectedViewController];
        }
    }
    else
    {
        vc = window.rootViewController;
    }
    return vc;
}
@end
