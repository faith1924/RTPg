//
//  LeanCloudInterface.h
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 ntygdff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LeanCloudResModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultModel)(LeanCloudResModel * reqModel);


@interface LeanCloudInterface : NSObject
/**
 提交数据数据
 
 @param className 类名
 @param keys 关键字
 @param result 返回结果
 */
+ (void) setClassInfo:(NSString *)className
               keyDic:(NSDictionary *)keys
               result:(void(^)(BOOL))result;

/**
 从云端获取数据
 
 @param className 配置类名
 */
+ (void) getClassInfo:(NSString *)className
               keyDic:(NSArray *)keys
               result:(void(^)(BOOL status,NSMutableArray * arr))result;

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
                   result:(void(^)(BOOL status))result;



/**
 登录

 @param username 用户名
 @param password 密码
 @param result 结果
 */
+ (void) userLoginName:(NSString *)username
              password:(NSString *)password
                result:(void(^)(BOOL status))result;

/**
 获取图片
 
 @param className 用户名
 @param result 结果
 */
+ (void) getUserThumbClass:(NSString *)className
                    result:(void(^)(BOOL status))result;


/**
 上传图片
 
 @param className 用户名
 @param image 上传的图片
 @param result 结果
 */
+ (void) uploadThumbClass:(NSString *)className
                    image:(UIImage *)image
                   result:(void(^)(BOOL status))result;

/**
 初次上传图片
 
 @param className 用户名
 @param image 上传的图片
 @param result 结果
 */
+ (void) regesterThumbClass:(NSString *)className
                      image:(UIImage *)image
                     result:(void(^)(BOOL status))result;

/**
 修改类参数值
 
 @param className 雷鸣
 @param dic 关键字
 @param result 回调
 */
+ (void) updataDataClass:(NSString *)className
               updataDic:(NSDictionary *)dic
                  result:(void(^)(BOOL status))result;

/**
 退出
 */
+ (void) logout;
+ (void) updataObjectID:(NSString *)userid;
@end

NS_ASSUME_NONNULL_END
