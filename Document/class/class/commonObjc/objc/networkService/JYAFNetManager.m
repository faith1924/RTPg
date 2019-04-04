//
//  JYAFNetManager.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYAFNetManager.h"
#import "AFNetworking.h"


@implementation JYAFNetManager
+ (instancetype)manager{
    return [[JYAFNetManager alloc]init];
}

- (void)POSTWithParameters:(NSMutableDictionary *)params Success:(Success)responseJson Failure:(Failure)error{
    
}

- (void)POSTWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)responseJson Failure:(Failure)error{
    
    NSAssert(!url, @"url is nil");
    
    if (![JYAfClient isExistenceNetwork]) {
        JYLog(@"网络连接不可用");
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [JYAfClient decodeResult:responseObject URL:url parameters:params successBlock:^(NSMutableDictionary *result, JYResultModel *model) {
            
        } failureBlock:^(NSError *error, JYResultModel *model) {
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [JYAfClient updateErrorToServiceWithUrl:url paramDict:params errorDesc:error.description];
    }];
}

- (void)POSTWithSubmitDocumentParameters:(NSMutableDictionary *)params UrlAddress:(NSString *)url Success:(Success)responseJson Failure:(Failure)error{
    NSAssert(!url, @"url is nil");
    
}

- (void)GetWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)responseJson Failure:(Failure)error{
    NSAssert(!url, @"url is nil");
    
}
- (void)syncGetWithURL:(NSString *)url Parameters:(NSMutableDictionary *)params Success:(Success)responseJson Failure:(Failure)error{
    NSAssert(!url, @"url is nil");
    
}
@end
