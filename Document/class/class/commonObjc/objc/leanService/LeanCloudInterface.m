//
//  LeanCloudInterface.m
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 蚂蚁区块链联盟. All rights reserved.
//

#import "LeanCloudInterface.h"
#import "AVOSCloud.h"

@implementation LeanCloudInterface


/**
 从云端获取数据

 @param className 配置类名
 */
+ (void) getClassInfo:(NSString *)className{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query getObjectInBackgroundWithId:LeanCloudID block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        
    }];
}

/**
 注册接口
 
 @param username 用户名
 @param password 密码
 @param email 邮箱
 @param result 返回结果
 */
+ (void) userRegesterName:(NSString *)username
                 password:(NSString *)password
                    email:(NSString *)email
                   result:(resultModel )result{

    if (username && password && email) {
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            LeanCloudResModel * model = [LeanCloudResModel new];
            if (succeeded) {
                model.result = [NSMutableDictionary new];
                model.status = succeeded;
            } else {
                model.status = NO;
                model.error = error;
            }
        }];
    }
}


/**
 登录
 
 @param username 用户名
 @param password 密码
 @param result 结果
 */
+ (void) userLoginName:(NSString *)username
              password:(NSString *)password
                result:(resultModel )result{
    
    if (username && password) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            LeanCloudResModel * model = [LeanCloudResModel new];
            if (error) {
                model.user = user;
                model.status = YES;
            } else {
                model.status = NO;
                model.error = error;
            }
            result(model);
        }];
    }
}

+ (void)logout{
    [AVUser logOut];
}
@end
