//
//  NSObject+Runtime.h
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Runtime)

/**
 获取所有属性变量

 @return 返回数组
 */
- (NSArray *)allProperties;


/**
 获取所有成员变量

 @return 返回数组
 */
- (NSArray *)allIvars;

/**
 获取所有方法

 @return 返回数组
 */
- (NSArray *)allMethors;



@end

NS_ASSUME_NONNULL_END
