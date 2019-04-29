//
//  booksVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class booksModel;

@interface booksVC : JYBasicViewController

@end

@interface booksCell : JYBasicCell

@property (strong , nonatomic) booksModel * model;

@end

@interface booksModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * sub1;//标题
@property (strong , nonatomic) NSString <Optional> * sub2;//内容
@property (strong , nonatomic) NSString <Optional> * reading;//阅读数
@property (strong , nonatomic) NSString <Optional> * catalog;//分类
@property (strong , nonatomic) NSString <Optional> * tags;//描述
@property (strong , nonatomic) NSString <Optional> * bytime;//发布时间

@property (strong , nonatomic) NSString <Optional> * img;//配图


@property (strong , nonatomic) NSString <Optional> * title;//标题
@property (strong , nonatomic) NSString <Optional> * url;//链接
@end

NS_ASSUME_NONNULL_END
