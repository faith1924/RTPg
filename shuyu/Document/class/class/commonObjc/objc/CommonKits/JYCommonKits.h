//
//  JYCommonKits.h
//  ABCMobileProject
//
//  Created by mylm on 2018/4/24.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABABasicUIButton.h"
#import "ABABasicUIControl.h"
#import "ABAUITextField.h"
#import "ABAUISearchBar.h"

@interface JYCommonKits : NSObject

/*************************UIImagesKit*******************************/

//***** 返回组图片

//获取一组图片
+ (NSMutableArray *)initWithGroupImages:(NSArray *)imagesPath;
+ (UIImageView *)initWithImageViewPath:(NSString *)imagePath;
+ (UIImage *)initImageWithPath:(NSString *)imagePath;

+ (NSMutableArray *)initWithCacheGroupImages:(NSArray *)imagesPath;
+ (UIImageView *)initImageViewWithCachePath:(NSString *)imagePath;
+ (UIImage *)initImageWithCachePath:(NSString *)imagePath;
/*
 ***** 添加某一张图片到父视图
*/
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImagePath:(NSString *)imagePath;

/*
 ***** 带V头像
 */
+ (UIImageView *)initVipHeaderImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImagePath:(NSString *)imagePath;

/*
 ***** 添加某一张图片到父视图
 */
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImage:(UIImage *)image;

/*
 ***** 添加某一张图片到父视图
 */
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView;

/*
 ***** 颜色转rgb图片
*/
+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;


/*************************UIButtonKits*******************************/
/**
 *  按钮初始化
 *  @param btnTitle 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 */
+ (ABABasicUIButton *)initButtonnWithButtonTitle:(NSString *)btnTitle
                           andLabelColor:(UIColor *)titleColor
                            andLabelFont:(float)fontSize
                            andSuperView:(UIView *)superView
                                andFrame:(CGRect)frame;

/**
 *  按钮初始化
 *  @param superView 父视图
 */
+ (UIControl *)initControlWithFrame:(CGRect )frame
                        andJoinView:(UIView *)superView;



/*************************UILabelKits*******************************/
/**
 *  按钮初始化
 *  @param labelDetail 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param font 字体
 *  @param fontSize 大小
 *  @param superView 父视图
 *  @param maxWidth 最大宽度
 */
+ (UILabel *) initLabelViewWithAutoSizeWithLabelDetail:(NSString *)labelDetail
                                        withLabelColor:(UIColor *)titleColor
                                              withFont:(UIFont *)font
                                          withFontSize:(float)fontSize
                                        withLabelFrame:(CGRect )frame
                                          withMaxWidth:(CGFloat)maxWidth
                                          withJoinView:(UIView *)superView;
/**
 *  按钮初始化
 *  @param labelDetail 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 */
+ (UILabel *)initLabelViewWithLabelDetail:(NSString *)labelDetail
                            andLabelColor:(UIColor *)titleColor
                             andLabelFont:(float )fontSize
                            andLabelFrame:(CGRect )frame
                              andJoinView:(UIView *)superView;

/**
 *  按钮初始化
 *  @param labelDetail 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 *  @param maxWidth 最大宽度
 */
+ (UILabel *)initLabelViewWithAutoSizeWithLabelDetail:(NSString *)labelDetail
                                        andLabelColor:(UIColor *)titleColor
                                         andLabelFont:(float )fontSize
                                        andLabelFrame:(CGRect )frame
                                         withMaxWidth:(CGFloat)maxWidth
                                          andJoinView:(UIView *)superView;

/*
 *  按钮初始化
 *  @param labelDetail 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 *  @param alignmentType 文本位置
 */
+ (UILabel *)initLabelViewWithLabelDetail:(NSString *)labelDetail
                         andTextAlignment:(int) alignmentType
                            andLabelColor:(UIColor *)titleColor
                             andLabelFont:(float )fontSize
                            andLabelFrame:(CGRect )frame
                              andJoinView:(UIView *)superView;

/*************************UITextFieldKits*******************************/
/**
 *  按钮初始化
 *  @param placeholder 提示文字
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 */
+(UITextField *)initTextfieldViewWithPlaceholder:(NSString *)placeholder
                                   andLabelColor:(UIColor *)titleColor
                                    andLabelFont:(float )fontSize
                                        andFrame:(CGRect )frame
                                     andJoinView:(UIView *)superView;

+ (UITextView *)initTextViewWithPlaceholder:(NSString *)placeholder
                               andTextColor:(UIColor *)titleColor
                                andTextFont:(float )fontSize
                                   andFrame:(CGRect )frame
                                andJoinView:(UIView *)superView;


/*************************画直线*******************************/
+ (UIView *)initializeViewLineWithFrame:(CGRect ) aFrame
                            andJoinView:(UIView *)superView;

+ (CALayer *)getLayerLineWithFrame:(CGRect ) aFrame
                       andJoinView:(UIView *)superView;

+ (UIView *)getViewLineWithFrame:(CGRect ) aFrame
                     andJoinView:(UIView *)superView;

@end

