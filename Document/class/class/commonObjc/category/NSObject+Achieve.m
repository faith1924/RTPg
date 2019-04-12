//
//  NSObject+Achieve.m
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "NSObject+Achieve.h"

@implementation NSObject (Achieve)
/**
 归档
 
 @param objc 对象
 */
- (void)JYAchieveDecode:(id )objc KEY:(NSString *)key filePath:(NSString *)path{
    
    if(objc == nil || key == nil || path == nil){return;}
    
    NSMutableData * data = [NSMutableData data];
    
    NSKeyedArchiver * archiver = [[NSKeyedArchiver alloc]initRequiringSecureCoding:data];
    
    [archiver encodeObject:objc forKey:key];
    
    [archiver finishEncoding];
    
    [data writeToFile:path atomically:YES];
}

/**
 解档/反归档
 
 @param objc 对象
 */
- (void)JYAchieveEncode:(id )objc KEY:(NSString *)key filePath:(NSString *)path{
    
}
@end
