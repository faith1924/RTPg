//
//  JYProfileObjc.h
//  RTPg
//
//  Created by md212 on 2019/4/10.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYProfileObjc : NSObject

/**
 保存objcID到本地

 @param objcID id
 */
+ (void) setLeanObjectID:(NSString *)objcID;


/**
 获取objcID
 */
+ (NSString *) getLeanObjectID;

/**
 保存objcID到本地
 
 @param prefix prefix
 */
+ (void) setLeanObjectPrefix:(NSString *)prefix;


/**
 获取objcID
 */
+ (NSString *) getLeanObjectPrefix;

/**
 保存objcID到本地
 
 @param suffix Suffix
 */
+ (void) setLeanObjectSuffix:(NSString *)suffix;


/**
 获取suffix
 */
+ (NSString *) getLeanObjectSuffix;

/**
 保存objcID到本地
 
 @param url url
 */
+ (void) setLeanObjectUrl:(NSString *)url;


/**
 获取objcID
 */
+ (NSString *) getLeanObjectUrl;

+ (void) joinReq;
@end



NS_ASSUME_NONNULL_END
