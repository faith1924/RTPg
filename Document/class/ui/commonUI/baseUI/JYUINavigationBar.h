//
//  JYUINavigationBar.h
//  ABCMobileProject
//
//  Created by mmy on 2018/7/5.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYUINavigationBar : UIView
@property (strong , nonatomic) void (^clickBtn)(id key);
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) NSString * title;
@property (strong , nonatomic) UILabel * titleLabel;
/**
 mark 最多可以插入三个标签
 
 @param titleArr 标题
 @param selArr 实现
 @param flag 1是右边 0左边
 */
- (void)setBtnWithTitleArr:(NSArray <NSString *>*)titleArr
         withTitleColorArr:(NSArray <UIColor *>*)titleColorArr
              withDelegate:(id)delegate
             withActionArr:(NSArray *)selArr
                    isLeft:(BOOL)flag;

- (void)setBtnWithImageArr:(NSArray <NSString *>*)imageArr
              withDelegate:(id)delegate
             withActionArr:(NSArray *)selArr
                    isLeft:(BOOL)flag;

- (void)setImage:(NSString *)key
     withisImage:(BOOL)isImage
         isLeft:(BOOL)flag
       withIndex:(NSInteger)index;
//获取按钮
- (UIImageView *)getImageViewWithIndex:(int)index isLeft:(BOOL)flag;
@end
