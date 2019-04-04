//
//  JYRequesModel.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/4.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYRequesModel : NSObject

@property (strong , nonatomic) NSString * link; //请求地址

@property (strong , nonatomic) NSMutableDictionary * parameters; //请求参数

@end

NS_ASSUME_NONNULL_END
