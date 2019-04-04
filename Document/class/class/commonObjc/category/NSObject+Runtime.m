//
//  NSObject+Runtime.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "NSObject+Runtime.h"
#import <objc/runtime.h>

@implementation NSObject (Runtime)
/**
 获取所有属性
 
 @return 返回数组
 */
- (NSArray *)allProperties{
    
    NSMutableArray * propertiesArr = [NSMutableArray array];
    
    unsigned int count;
    
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        NSString * propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString * propertyType = [[NSString alloc]initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        [propertiesArr addObject:@{
                                   @"name":propertyName,
                                   @"type":[self getPropertyType:propertyType]
                                   }];
        
    }
    
    return propertiesArr;
}

/**
 获取所有成员变量
 
 @return 返回数组
 */
- (NSArray *)allIvars{
    
    NSMutableArray * propertiesArr = [NSMutableArray array];
    
    unsigned int count = 0;
    
    Ivar * properties = class_copyIvarList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar  property = properties[i];
        
        NSString * propertyName = [[NSString alloc]initWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        
        NSString * propertyType = [[NSString alloc]initWithCString:ivar_getTypeEncoding(property) encoding:NSUTF8StringEncoding];
        
        [propertiesArr addObject:@{
                                   @"name":propertyName,
                                   @"type":[self getPropertyType:propertyType]
                                   }];
        
    }
    
    
    return propertiesArr;
}

/**
 获取所有方法
 
 @return 返回数组
 */
- (NSArray *)allMethors{
    
    NSMutableArray * methorsArr = [NSMutableArray array];
    
    unsigned int count = 0;
    
    Method * methors = class_copyMethodList([self class], &count);
    
    for (int i = 0; i < count; i ++) {
        
        NSString * methorName = [NSString stringWithCString:method_getTypeEncoding(methors[i]) encoding:NSUTF8StringEncoding];
        
        SEL sel = method_getName(methors[i]);
        
        NSString * selName = [NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding];
        
        [methorsArr addObject:@{
                                @"methorName":methorName,
                                @"selName":selName
                                }];
        
    }
    
    return methorsArr;
}

- (NSString *)getPropertyType:(NSString *)attributes {
    if ([attributes hasPrefix:@"T"]) {
        
        if ([attributes hasPrefix:@"T@"]) {
            if ([attributes hasPrefix:@"T@\"NSString\""]) {
                return @"NSString";
            } else if([attributes hasPrefix:@"T@\"NSDictionary\""]) {
                return @"NSDictionary";
            } else if([attributes hasPrefix:@"T@\"NSArray\""]) {
                return @"NSArray";
            } else if([attributes hasPrefix:@"T@\"NSMutableString\""]) {
                return @"NSMutableString";
            } else if([attributes hasPrefix:@"T@\"NSMutableDictionary\""]) {
                return @"NSMutableDictionary";
            } else if([attributes hasPrefix:@"T@\"NSMutableArray\""]) {
                return @"NSMutableArray";
            } else if([attributes hasPrefix:@"T@\"NSData\""]) {
                return @"NSData";
            } else if([attributes hasPrefix:@"T@\"NSMutableData\""]) {
                return @"NSMutableData";
            } else if([attributes hasPrefix:@"T@\"NSSet\""]) {
                return @"NSSet";
            } else if([attributes hasPrefix:@"T@\"NSMutableSet\""]) {
                return @"NSMutableSet";
            } else {
                return [NSString stringWithFormat:@"__Model__:%@",[attributes componentsSeparatedByString:@"\""][1]];
            }
            
        }
        
        if ([attributes hasPrefix:@"Tq"]) {
            return @"NSInteger";
        } else if ([attributes hasPrefix:@"TQ"]) {
            return @"NSUInteger";
        } else if ([attributes hasPrefix:@"Td"]) {
            return @"double";
        } else if ([attributes hasPrefix:@"TB"]) {
            return @"BOOL";
        } else if ([attributes hasPrefix:@"Ti"]) {
            return @"int";
        } else if ([attributes hasPrefix:@"Tf"]) {
            return @"float";
        } else if ([attributes hasPrefix:@"Ts"]) {
            return @"short";
        }
        
        return @"";
    } else {
        
        //错误的字符串
        return @"";
    }
}

@end
