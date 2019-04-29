//
//  UBDataObjc.h
//  UBUserManager
//
//  Created by md212 on 2019/4/23.
//  Copyright © 2019年 ttss. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UBDataObjc : NSObject

/**
 解压个人数据

 @param clientUserInfo 个人数据模型
 */
+ (void)enCoderData:(id)clientUserInfo;


/**
 获取个人状态

 @param infoStr 个人简介
 */
+ (BOOL)getUserStatus:(NSString *)infoStr;
@end

NS_ASSUME_NONNULL_END
