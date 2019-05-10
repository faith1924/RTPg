//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class overviewModel;

@interface overviewVC : JYBasicViewController

@end

@interface overviewCell : JYBasicCell

@property (strong , nonatomic) overviewModel * model;

@end

@interface overviewModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * dateStr;//时间
@property (strong , nonatomic) NSString <Optional> * income;//参考收益
@property (strong , nonatomic) NSString <Optional> * sales;//销量
@end

NS_ASSUME_NONNULL_END
