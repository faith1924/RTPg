//
//  NSString+iPhone.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

//获取设备相关参数

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (iPhone)

//获取手机型号
+ (NSString *)deviceModel;

//获取设备别名
+ (NSString *)phoneName;
@end

NS_ASSUME_NONNULL_END

