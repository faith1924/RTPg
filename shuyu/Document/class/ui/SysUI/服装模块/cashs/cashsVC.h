//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class cashsModel;

@interface cashsVC : JYBasicViewController

@end

@interface cashsCell : JYBasicCell

@property (strong , nonatomic) cashsModel * model;

@end

@interface cashsModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * dateStr;//时间
@property (strong , nonatomic) NSString <Optional> * income;//参考收益
@property (strong , nonatomic) NSString <Optional> * totalIncome;//总收入
@property (strong , nonatomic) NSString <Optional> * totalOutcome;//总支出
@end

NS_ASSUME_NONNULL_END
