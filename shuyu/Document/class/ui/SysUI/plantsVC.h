//
//  plantsVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class plantsModel;

@interface plantsVC : JYBasicViewController

@end

@interface plantsCell : JYBasicCell

@property (strong , nonatomic) plantsModel * model;

@end

@interface plantsModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * title;//标题
@property (strong , nonatomic) NSString <Optional> * title_plain;//内容
@property (strong , nonatomic) NSString <Optional> * reading;//阅读数
@property (strong , nonatomic) NSString <Optional> * tags;//描述
@property (strong , nonatomic) NSString <Optional> * bytime;//发布时间

@property (strong , nonatomic) NSString <Optional> * img;//配图
@property (strong , nonatomic) NSString <Optional> * url;//链接
@property (strong , nonatomic) NSString <Optional> * sub2;//副标题
@property (strong , nonatomic) NSString <Optional> * catalog;//归类


@end

NS_ASSUME_NONNULL_END
