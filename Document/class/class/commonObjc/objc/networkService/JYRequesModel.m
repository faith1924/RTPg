//
//  JYRequesModel.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYRequesModel.h"

@implementation JYRequesModel
- (NSString *)getFilePath{
    if (_link == nil && _parameters == nil) {
        return nil;
    }
    NSArray *keyArray = [_parameters allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (int  i = 0; i < sortArray.count; i++) {
        
    }
    
    return @"";
}
@end
