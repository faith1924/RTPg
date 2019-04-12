//
//  JYDataBase.m
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYDataBase.h"

@implementation JYDataBase
/**
 保存所请求的数据到本地
 
 @param params 请求参数
 @param url 请求地址
 @param type 保存目录
 @return 保存状态
 */
+ (BOOL)saveFileParameters:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type{
    
    BOOL result = NO;
    
    NSAssert(!params, @"save data fail,params is nil");
    
    
    return result;
}


/**
 获取本地数据
 
 @param params 请求参数
 @param url 请求地址
 @return 返回数据
 */

+ (id)getFileParameters:(NSMutableDictionary *)params URL:(NSString *)url{
    id result = nil;
    
    
    return result;
}

/**
 获取本地数据
 
 @param params 请求参数
 @param url 请求地址
 @param type 保存目录
 @return 返回数据
 */
+ (id)getFileParameters:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type{
    id result = nil;
    
    
    return result;
}

/**
 删除指定数据
 
 @param params params description请求参数
 @param url 请求地址
 @param type 保存目录
 @return 返回删除结果
 */
+ (BOOL)deleteDiskFileParameters:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type{
    BOOL result = NO;
    
    return result;
}

#pragma -mark 返回单个文件的大小
+ (long long)diskFileSizeAtPath:(NSString *)path{
    float result = 0;
    
    return result;
}

#pragma -mark 获取所有缓存大小
+ (float )diskCacheSize{
    float result = 0;
    
    return result;
}

#pragma -mark 获取指定目录大小
+ (float )diskCacheSizeType:(sankBoxtype)type{
    float result = 0;
    
    return result;
}

/**
 删除指定目录数据
 
 @param type 指定目录
 @return 返回结果
 */
+ (BOOL)deleteFileType:(sankBoxtype)type{
    BOOL result = NO;
    
    return result;
}

/**
 删除所有缓存数据
 
 @return 返回结果
 */
+ (BOOL)clearAllFile{
    BOOL result = NO;
    
    return result;
}


@end
