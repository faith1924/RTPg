//
//  JYBasicModel.m
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicModel.h"

@implementation JYBasicModel
- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    if (self = [super initWithDictionary:dict error:err]) {
        _cellHeight = [NSNumber numberWithInt:1];
    }
    return self;
}
@end
