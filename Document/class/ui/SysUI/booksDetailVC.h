//
//  booksDetailVC.h
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface booksDetailVC : JYBasicViewController

@property (strong , nonatomic) NSMutableDictionary * data;

@end

NS_ASSUME_NONNULL_END

@interface headerView : UIView

@property (strong , nonatomic) UIImageView * image;

@property (strong , nonatomic) UILabel * sub1;

@property (strong , nonatomic) UILabel * reading;

@end
