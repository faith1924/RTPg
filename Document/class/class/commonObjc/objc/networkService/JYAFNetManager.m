//
//  JYAFNetManager.m
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYAFNetManager.h"
#import "AFNetworking.h"


@implementation JYAFNetManager
+ (instancetype)manager{
    return [[JYAFNetManager alloc]init];
}

- (void)POSTWithParameters:(NSMutableDictionary *)params Success:(Success)success Failure:(Failure)error{
    
}

- (void)POSTWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)success Failure:(Failure)failure{
    
    [self logReq:url params:params];
    
    if (![JYAfClient isExistenceNetwork]) {
        JYLog(@"网络连接不可用");
    }

    [[AFHTTPSessionManager manager] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JYAfClient decodeResult:responseObject URL:url parameters:params successBlock:^(NSMutableDictionary *result, JYResultModel *model) {
            success(result);
        } failureBlock:^(NSError *error, JYResultModel *model) {
            failure(error);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [JYAfClient updateErrorToServiceWithUrl:url paramDict:params errorDesc:error.description];
    }];
}

- (void)POSTWithSubmitDocumentParameters:(NSMutableDictionary *)params UrlAddress:(NSString *)url Success:(Success)success Failure:(Failure)error{
    [self logReq:url params:params];
    
}

- (void)GetWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)success Failure:(Failure)failure{
    
    [self logReq:url params:params];
    
    if (![JYAfClient isExistenceNetwork]) {
        JYLog(@"网络连接不可用");
    }
    
    [[AFHTTPSessionManager manager] GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [JYAfClient decodeResult:responseObject URL:url parameters:params successBlock:^(NSMutableDictionary *result, JYResultModel *model) {
            success(result);
        } failureBlock:^(NSError *error, JYResultModel *model) {
            failure(error);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [JYAfClient updateErrorToServiceWithUrl:url paramDict:params errorDesc:error.description];
    }];
}
- (void)syncGetWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)success Failure:(Failure)error{
    NSAssert(!url, @"url is nil");
    
}
- (void) logReq:(NSString *)url params:(NSMutableDictionary *)params{
     JYLog(@"\n====================================================\n请求地址：%@\n请求参数：%@\n",url,params);
}
@end
