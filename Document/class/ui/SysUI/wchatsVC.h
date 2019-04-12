//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class wchatsModel;

@interface wchatsVC : JYBasicViewController

@end

@interface wchatsCell : JYBasicCell

@property (strong , nonatomic) wchatsModel * model;

@end

@interface wchatsModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * title;//内容
@property (strong , nonatomic) NSString <Optional> * url;//来源网址
@property (strong , nonatomic) NSString <Optional> * source;//来源
@end

NS_ASSUME_NONNULL_END
