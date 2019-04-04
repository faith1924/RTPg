//
//  NSObject+Achieve.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Achieve)<NSCoding>

/**
 归档

 @param objc 对象
 @param key 路径
 */
- (void)JYAchieveDecode:(id )objc KEY:(NSString *)key;

/**
 解档/反归档

 @param objc 对象
 @param key 路径
 */
- (void)JYAchieveEncode:(id )objc KEY:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
