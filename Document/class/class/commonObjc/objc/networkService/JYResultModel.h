//
//  JYResultModel.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYResultModel : NSObject

@property (strong , nonatomic) id result;

@property (strong , nonatomic) NSError  * error;

@end

NS_ASSUME_NONNULL_END
