//
//  NSObject+Achieve.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "NSObject+Achieve.h"

@implementation NSObject (Achieve)
/**
 归档
 
 @param objc 对象
 */
- (void)JYAchieveDecode:(id )objc KEY:(NSString *)key{
    
    NSMutableData * data = [NSMutableData data];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initRequiringSecureCoding:data];
    

    [archiver finishEncoding];
}

/**
 解档/反归档
 
 @param objc 对象
 */
- (void)JYAchieveEncode:(id )objc KEY:(NSString *)key{
    
}
@end
