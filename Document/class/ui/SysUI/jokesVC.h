//
//  episodeVC.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class jokesModel;

@interface jokesVC : JYBasicViewController

@end

@interface jokesCell : JYBasicCell

@property (strong , nonatomic) jokesModel * model;

@end

@interface jokesModel :JYBasicModel
@property (strong , nonatomic) NSString <Optional> * content;//内容
@property (strong , nonatomic) NSString <Optional> * updatetime;//更新时间
@end

NS_ASSUME_NONNULL_END
