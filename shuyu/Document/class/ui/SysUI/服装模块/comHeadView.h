//
//  comHeadView.h
//  RTPg
//
//  Created by md212 on 2019/5/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYBasicView.h"

NS_ASSUME_NONNULL_BEGIN

@interface comHeadView : JYBasicView

@property (strong , nonatomic) NSArray * titleArr;

@property (strong , nonatomic) NSArray * iconArr;

@property (weak , nonatomic) void(^clickBtn)(NSString * title,NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr iconArr:(NSArray *)iconArr;

@end

NS_ASSUME_NONNULL_END
