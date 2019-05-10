//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class qualitysModel;

@interface qualitysVC : JYBasicViewController

@end

@interface qualitysCell : JYBasicCell

@property (strong , nonatomic) qualitysModel * model;

@end

@interface qualitysModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * img;//图片
@property (strong , nonatomic) NSString <Optional> * name;//衣服名字
@property (strong , nonatomic) NSString <Optional> * sale;//销量
@property (strong , nonatomic) NSString <Optional> * stock;//库存
@property (strong , nonatomic) NSString <Optional> * percent;//售出比例
@property (strong , nonatomic) NSString <Optional> * backPercent;//退货比例
@property (strong , nonatomic) NSString <Optional> * backGoods;
@property (strong , nonatomic) NSString <Optional> * resource;//进货渠道
@property (strong , nonatomic) NSString <Optional> * timestamp;//进货渠道
@end

NS_ASSUME_NONNULL_END
