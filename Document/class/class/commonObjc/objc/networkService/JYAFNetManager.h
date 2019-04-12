//
//  JYAFNetManager.h
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(id success);
typedef void(^Failure)(NSError * error);

NS_ASSUME_NONNULL_BEGIN

@interface JYAFNetManager : NSObject
+ (instancetype)manager;


/**
 Post异步请求方法1

 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POSTWithParameters:(NSMutableDictionary *)params
                   Success:(Success )success
                   Failure:(Failure )failure;


/**
 Post异步请求方法2

 @param url 请求地址
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POSTWithURL:(NSString *)url
         Parameters:(NSMutableDictionary *)params
            Success:(Success)success
            Failure:(Failure)failure;


/**
 Post异步请求方法3-上传文件

 @param params 上传参数
 @param url 上传地址
 @param success 成功回调
 @param failure 失败回调
 */
- (void)POSTWithSubmitDocumentParameters:(NSMutableDictionary *)params
                              UrlAddress:(NSString *)url
                                 Success:(Success)success
                                 Failure:(Failure)failure;




/**
 Get异步请求

 @param url 请求地址
 @param params 请求参数
 @param success 成功回调
 @param failure 失败回调
 */
- (void)GetWithURL:(NSString *)url
        Parameters:(NSMutableDictionary *)params
        Success:(Success)success
        Failure:(Failure)failure;

 /**
  Get同步请求
 
  @param url 请求地址
  @param params 请求参数
  @param success 成功回调
  @param failure 失败回调
  */
- (void)syncGetWithURL:(NSString *)url
            Parameters:(NSMutableDictionary *)params
               Success:(Success)success
               Failure:(Failure)failure;
@end


NS_ASSUME_NONNULL_END
/**
 重写NSCondition
 
 原因：如果wait类函数后于signal调用,就会一直等待,也就是说signal线程比wait快执行
 注意：尽量做2个线程之间的同步,否则可能结果不符合预期
 */
@interface MYNSCondition : NSCondition

@end
