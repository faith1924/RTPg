//
//  JYAfClient.h
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 数据处理成功回调

 @param result 数据
 */
typedef void(^decodeSuccess)(NSMutableDictionary * result,JYResultModel * model);

typedef void(^decodeFailure)(NSError * error,JYResultModel * model);
NS_ASSUME_NONNULL_BEGIN

@interface JYAfClient : NSObject

#pragma mark - ----------------------- 为了兼容NetHttpsManager，开放以下方法 -----------------------

/**
 判断当前网络状态
 
 @return 返回状态值
 */
+ (BOOL)isExistenceNetwork;

/**
 非指定url时，获取url
 
 @param parmDict 底层参数
 @return 返回URL
 */
+ (NSString *)getUrlStr:(NSMutableDictionary *)parmDict;

/**
 底层参数组装
 
 @param parmDict 传入的参数
 @param urlStr URL地址
 @return 返回组装后的参数
 */
+ (NSMutableDictionary *)getLocalParm:(NSMutableDictionary *)parmDict url:(NSString *)urlStr;

/**
 保存cookie
 */
+ (void)myCookieStorage;

/**
 处理网络请求成功结果
 
 @param responseObject 请求返回的数据（当前是NSData类型）
 @param urlStr 请求的链接
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)decodeResult:(id)responseObject
                 URL:(NSString *)urlStr
          parameters:(NSMutableDictionary *)params
        successBlock:(decodeSuccess)success
        failureBlock:(decodeFailure)failure;


/**
 处理请求失败

 @param url 服务器地址
 @param params 请求参数
 @param error 错误详情
 */
+ (void)failRequestUrl:(NSString *)url
            parameters:(NSMutableDictionary *)params
                 error:(NSError *)error;


/**
 处理网络请求失败
 
 @param urlStr 请求的链接
 @param params 请求参数
 @param errorDesc 错误描述
 */
+ (void)updateErrorToServiceWithUrl:(NSString *)urlStr
                          paramDict:(NSMutableDictionary *)params
                          errorDesc:(NSString *)errorDesc;

@end

NS_ASSUME_NONNULL_END
