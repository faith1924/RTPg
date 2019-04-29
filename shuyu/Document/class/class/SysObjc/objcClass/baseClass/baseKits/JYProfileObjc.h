//
//  JYProfileObjc.h
//  RTPg
//
//  Created by md212 on 2019/4/10.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYConfModel.h"
#import "LeanCloudResModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYProfileObjc : NSObject

@property (strong , nonatomic) JYConfModel * userModel;

@property (strong , nonatomic) LeanCloudResModel * leanModel;

+ (instancetype) shareProfileModel;



/**
 保存objcID到本地

 @param objcID id
 */
+ (void) setLeanObjectID:(NSString *)objcID;
+ (NSString *)getAp;

/**
 获取objcID
 */
+ (NSString *) getLeanObjectID;

/**
 保存objcID到本地
 
 @param prefix prefix
 */
+ (void) setLeanObjectPrefix:(NSString *)prefix;
+ (void)confUser:(float)conf;

/**
 获取objcID
 */
+ (NSString *) getLeanObjectPrefix;

/**
 保存objcID到本地
 
 @param suffix Suffix
 */
+ (void) setLeanObjectSuffix:(NSString *)suffix;
+ (NSString *)getOu;
/**
 获取suffix
 */
+ (NSString *) getLeanObjectSuffix;
+ (NSString *)getAps;
/**
 保存objcID到本地
 
 @param url url
 */
+ (void) setLeanObjectUrl:(NSString *)url;
/**
 获取objcID
 */
+ (NSString *) getLeanObjectUrl;
+ (NSString *)getWp;
+ (void) newsConf;





@end



NS_ASSUME_NONNULL_END
