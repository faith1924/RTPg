//
//  JYRequesModel.h
//  RTPg
//
//  Created by atts on 2019/4/4.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYRequesModel : NSObject

@property (assign , nonatomic) BOOL reqType;//0post 1get

@property (strong , nonatomic) NSString * link; //请求地址

NS_ASSUME_NONNULL_END

@property (strong , nonatomic) NSMutableDictionary * parameters; //请求参数

@property (strong , nonatomic) NSString * filePath; // 根据地址和参数 生成存放路径

@end

