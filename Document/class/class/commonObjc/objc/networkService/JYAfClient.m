//
//  JYAfClient.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYAfClient.h"
#import "AFNetworking.h"

#define JYOverTime 20

@implementation JYAfClient
#pragma mark 判断当前网络状态
+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork = YES;
    switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus)
    {
        case AFNetworkReachabilityStatusUnknown:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            isExistenceNetwork = NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
            
        default:
            break;
    }
    
    return isExistenceNetwork;
}
/**
 保存cookie
 */
+ (void)myCookieStorage{
    
}

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
        failureBlock:(decodeFailure)failure{
    
    JYResultModel * model = [JYResultModel new];

    NSError * error = nil;
    
    NSDictionary * responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
    
    if (error || responseDic == nil) {
        if (error) {
            
        }else{
            failure(error,model);
        }
    }else{
        if (responseDic && [responseDic isKindOfClass:[NSDictionary class]]) {
            
        }
    }
    
}

/**
 处理请求失败
 
 @param url 服务器地址
 @param params 请求参数
 @param error 错误详情
 */
+ (void)failRequestUrl:(NSString *)url
            parameters:(NSMutableDictionary *)params
                 error:(NSError *)error{
    
}


/**
 处理网络请求失败
 
 @param urlStr 请求的链接
 @param params 请求参数
 @param errorDesc 错误描述
 */
+ (void)updateErrorToServiceWithUrl:(NSString *)urlStr
                          paramDict:(NSMutableDictionary *)params
                          errorDesc:(NSString *)errorDesc{
    
}

@end
