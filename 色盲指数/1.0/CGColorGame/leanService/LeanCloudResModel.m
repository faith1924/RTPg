//
//  LeanCloudResModel.m
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 ntygdff. All rights reserved.
//

#import "LeanCloudResModel.h"
#define defaultPosition 0
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
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"loginUserStatus"];
}
- (void)setStatus:(BOOL)status{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"loginUserStatus"];
}
- (NSDictionary *)userInfo{
    if (self.status == NO || [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"] == nil) {
        return @{@"username":@"未登录",@"objectId":@"          ",@"password":@""};
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
}
- (void)setUserInfo:(NSDictionary *)userInfo{
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
}
- (void)setClientUserInfo:(NSArray *)clientUserInfo{
    NSMutableDictionary * dic = clientUserInfo[defaultPosition];
    self.name = dic[@"name"];
    self.age = dic[@"age"];
    self.sex = [dic[@"sex"] boolValue];
    self.userid = dic[@"userid"];
    self.desc = dic[@"desc"];
}
@end
