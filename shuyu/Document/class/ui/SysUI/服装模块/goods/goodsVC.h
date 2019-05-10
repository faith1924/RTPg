//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class goodsModel;

@interface goodsVC : JYBasicViewController

@end

@interface goodsCell : JYBasicCell

@property (strong , nonatomic) goodsModel * model;

@end

@interface goodsModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * img;//图片
@property (strong , nonatomic) NSString <Optional> * name;//衣服名字
@property (strong , nonatomic) NSString <Optional> * totleCloseNumber;//总库存
@property (strong , nonatomic) NSString <Optional> * resource;//渠道
@property (strong , nonatomic) NSString <Optional> * isSaling;
@property (strong , nonatomic) NSString <Optional> * isSalingStr;//是否在售
@property (strong , nonatomic) NSString <Optional> * inPrize;//进价
@end

NS_ASSUME_NONNULL_END
