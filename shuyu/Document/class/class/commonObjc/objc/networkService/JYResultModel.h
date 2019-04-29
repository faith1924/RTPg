//
//  JYResultModel.h
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYResultModel : NSObject

@property (strong , nonatomic) id result;

@property (strong , nonatomic) NSError  * error;

@end

NS_ASSUME_NONNULL_END
