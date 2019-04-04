//
//  JYAFNetManager.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(NSDictionary *responseJson);
typedef void(^Failure)(NSError * error);

NS_ASSUME_NONNULL_BEGIN

@interface JYAFNetManager : NSObject
+ (instancetype)manager;


/**
 Post异步请求方法1

 @param params 请求参数
 @param responseJson 成功回调
 @param error 失败回调
 */
- (void)POSTWithParameters:(NSMutableDictionary *)params
                   Success:(Success )responseJson
                   Failure:(Failure )error;


/**
 Post异步请求方法2

 @param url 请求地址
 @param params 请求参数
 @param responseJson 成功回调
 @param error 失败回调
 */
- (void)POSTWithURL:(NSString *)url
         Parameters:(NSMutableDictionary *)params
            Success:(Success)responseJson
            Failure:(Failure)error;


/**
 Post异步请求方法3-上传文件

 @param params 上传参数
 @param url 上传地址
 @param responseJson 成功回调
 @param error 失败回调
 */
- (void)POSTWithSubmitDocumentParameters:(NSMutableDictionary *)params
                              UrlAddress:(NSString *)url
                                 Success:(Success)responseJson
                                 Failure:(Failure)error;




/**
 Get异步请求

 @param url 请求地址
 @param params 请求参数
 @param responseJson 成功回调
 @param error 失败回调
 */
- (void)GetWithURL:(NSString *)url
        Parameters:(NSMutableDictionary *)params
        Success:(Success)responseJson
        Failure:(Failure)error;

 /**
  Get同步请求
 
  @param url 请求地址
  @param params 请求参数
  @param responseJson 成功回调
  @param error 失败回调
  */
- (void)syncGetWithURL:(NSString *)url
            Parameters:(NSMutableDictionary *)params
               Success:(Success)responseJson
               Failure:(Failure)error;
@end


NS_ASSUME_NONNULL_END
/**
 重写NSCondition
 
 原因：如果wait类函数后于signal调用,就会一直等待,也就是说signal线程比wait快执行
 注意：尽量做2个线程之间的同步,否则可能结果不符合预期
 */
@interface MYNSCondition : NSCondition

@end
