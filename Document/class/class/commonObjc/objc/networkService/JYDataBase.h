//
//  JYDataBase.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, sankBoxtype){
    NSSankBoxDocument = 0,
    NSSankBoxLibrary = 1,
    NSSankBoxTmp = 2,
};

NS_ASSUME_NONNULL_BEGIN

@interface JYDataBase : NSObject



/**
 保存所请求的数据到本地

 @param params 请求参数
 @param url 请求地址
 @param type 保存目录
 @return 保存状态
 */
+ (BOOL)saveFilePath:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type;


/**
 获取本地数据

 @param params 请求参数
 @param url 请求地址
 @param type 保存目录
 @return 返回数据
 */
+ (id)getFilePath:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type;

/**
 删除指定数据

 @param params params description请求参数
 @param url 请求地址
 @param type 保存目录
 @return 返回删除结果
 */
+ (BOOL)deleteDiskFilePath:(NSMutableDictionary *)params URL:(NSString *)url Type:(sankBoxtype)type;

#pragma -mark 返回单个文件的大小
+ (long long)diskFileSizeAtPath:(NSString *)filePat;

#pragma -mark 获取所有缓存大小
+ (float )diskCacheSize;

#pragma -mark 获取指定目录大小
+ (float )diskCacheSizeType:(sankBoxtype)type;

/**
 删除指定目录数据

 @param type 指定目录
 @return 返回结果
 */
+ (BOOL)deleteFileType:(sankBoxtype)type;

/**
 删除所有缓存数据

 @return 返回结果
 */
+ (BOOL)clearAllFile;


@end

NS_ASSUME_NONNULL_END
