//
//  JYTabBar.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface JYTabBar : UITabBar

/**
 中间按钮
 */
@property (nonatomic, strong) UIButton *centerBtn;

/**
 默认选中的图片
 */
@property (nonatomic, strong) UIImageView *defaultImageView;

/**
 默认选中的图片
 */
@property (nonatomic, strong) UIImage * centerDefaultImage;

/**
 中间按钮图片
 */
@property (nonatomic, strong) UIImage *centerImage;
/**
 中间按钮选中图片
 */
@property (nonatomic, strong) UIImage *centerSelectedImage;

/**
 中间按钮偏移量,两种可选，也可以使用centerOffsetY 自定义
 */
@property (nonatomic, assign) JYTabBarType position;

/**
 中间按钮偏移量，默认是居中
 */
@property (nonatomic, assign) CGFloat centerOffsetY;

/**
 中间按钮的宽和高，默认使用图片宽高
 */
@property (nonatomic, assign) CGFloat centerWidth, centerHeight;
@end

NS_ASSUME_NONNULL_END
