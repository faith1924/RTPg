//
//  LeanCloudResModel.m
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 mylm. All rights reserved.
//

#import "LeanCloudResModel.h"

@implementation LeanCloudResModel
+ (instancetype) shareCloudModel{
    static LeanCloudResModel * onceObjcToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceObjcToken = [[super allocWithZone:NULL] init];
    });
    return onceObjcToken;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [LeanCloudResModel shareCloudModel];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [LeanCloudResModel shareCloudModel];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [LeanCloudResModel shareCloudModel];
}

- (BOOL)status{
    return [JYGetUserDefault boolForKey:@"loginStatus"];
}
- (void)setStatus:(BOOL)status{
    [JYGetUserDefault setBool:status forKey:@"loginStatus"];
}
- (NSDictionary *)userInfo{
    if (self.status == NO || [JYGetUserDefault objectForKey:@"userInfo"] == nil) {
        return @{@"username":@"未登录",@"objectId":@"          ",@"password":@""};
    }
    return [JYGetUserDefault objectForKey:@"userInfo"];
}
- (void)setUserInfo:(NSDictionary *)userInfo{
    [JYGetUserDefault setObject:userInfo forKey:@"userInfo"];
}

@end
