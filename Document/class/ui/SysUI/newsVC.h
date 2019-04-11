//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class newsModel;

@interface newsVC : JYBasicViewController

@end

@interface newsCell : JYBasicCell

@property (strong , nonatomic) newsModel * model;

@end

@interface newsModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * author_name;//作者
@property (strong , nonatomic) NSString <Optional> * category;//分类
@property (strong , nonatomic) NSString <Optional> * desc;//描述
@property (strong , nonatomic) NSString <Optional> * date;//发布时间

@property (strong , nonatomic) NSString <Optional> * thumbnail_pic_s;//配图
@property (strong , nonatomic) NSString <Optional> * thumbnail_pic_s02;//配图
@property (strong , nonatomic) NSString <Optional> * thumbnail_pic_s03;//配图
@property (strong , nonatomic) NSMutableArray <Optional> * imageArr;



@property (strong , nonatomic) NSString <Optional> * title;//标题
@property (strong , nonatomic) NSString <Optional> * url;//链接
@end

NS_ASSUME_NONNULL_END
