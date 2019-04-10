//
//  LeanCloudInterface.h
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 蚂蚁区块链联盟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanCloudResModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultModel)(LeanCloudResModel * resultModel);


@interface LeanCloudInterface : NSObject

/**
 从云端获取数据
 
 @param className 配置类名
 */
+ (void) getClassInfo:(NSString *)className;

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
                   result:(resultModel )result;



/**
 登录

 @param username 用户名
 @param password 密码
 @param result 结果
 */
+ (void) userLoginName:(NSString *)username
              password:(NSString *)password
                result:(resultModel )result;


/**
 退出
 */
+ (void) logout;

@end

NS_ASSUME_NONNULL_END
