//
//  NSString+Md5.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Md5)

/**
 获取字符串的hash值

 @return 返回小写哈希值
 */
- (NSString *)lowerMd5Hash;

/**
 获取字符串的hash值
 
 @return 返回大写哈希值
 */
- (NSString *)upperMd5Hash;

@end

NS_ASSUME_NONNULL_END
