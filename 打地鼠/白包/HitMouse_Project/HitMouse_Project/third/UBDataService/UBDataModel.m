//
//  UBDataModel.m
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 ntygdff. All rights reserved.
//

#import "UBDataModel.h"
#define defaultPosition 0
@implementation UBDataModel
+ (instancetype) shareCloudModel{
    static UBDataModel * onceObjcToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceObjcToken = [[super allocWithZone:NULL] init];
    });
    return onceObjcToken;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [UBDataModel shareCloudModel];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [UBDataModel shareCloudModel];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [UBDataModel shareCloudModel];
}
@end
