//
//  JYCommonKits.m
//  ABCMobileProject
//
//  Created by mylm on 2018/4/24.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "JYCommonKits.h"

@implementation JYCommonKits
//不带缓存
+ (NSMutableArray *)initWithGroupImages:(NSArray *)imagesPath{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int x = 0; x < imagesPath.count; x++) {
        UIImageView * imageView = [self initWithImageViewPath:imagesPath[x]];
        [array addObject:imageView];
    }
    return array;
}
+ (UIImageView *)initWithImageViewPath:(NSString *)imagePath{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagePath]];
    return imageView;
}
+ (UIImage *)initImageWithPath:(NSString *)imagePath{
    UIImage *image = [UIImage imageNamed:imagePath];
    return image;
}
//带缓存加载图片
+ (NSMutableArray *)initWithCacheGroupImages:(NSArray *)imagesPath{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int x = 0; x < imagesPath.count; x++) {
        UIImageView * imageView = [self initImageViewWithCachePath:imagesPath[x]];
        [array addObject:imageView];
    }
    return array;
}
+ (UIImageView *)initImageViewWithCachePath:(NSString *)imagePath{
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[self initImageWithCachePath:imagePath]];
    return imageView;
}
+ (UIImage *)initImageWithCachePath:(NSString *)imagePath{
    return [UIImage imageNamed:imagePath];
}
//rgb转图片
+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame
{
    aFrame = CGRectMake(0, 0, aFrame.size.width, aFrame.size.height);
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, aFrame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
/*
 ***** 带V头像
 */
+ (UIImageView *)initVipHeaderImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImagePath:(NSString *)imagePath{
    UIImageView * imageView = [self initWithImageViewPath:imagePath];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = tFrame;
    [superView addSubview:imageView];
    return imageView;
}
//添加图片到某父视图
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImagePath:(NSString *)imagePath{
    if ([imagePath isEqualToString:@""]||imagePath == nil) {
        imagePath = @"loadingImage";
    }
    UIImageView * imageView = [self initWithImageViewPath:imagePath];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = tFrame;
    [superView addSubview:imageView];
    return imageView;
}
/*
 ***** 添加某一张图片到父视图
 */
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = tFrame;
    [superView addSubview:imageView];
    return imageView;
}
/*
 ***** 添加某一张图片到父视图
 */
+ (UIImageView *)initWithImageViewWithFrame:(CGRect)tFrame AndSuperView:(UIView *)superView AndImage:(UIImage *)image{
    if (image==nil) {
        image = defaultImage;
    }
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = tFrame;
    [superView addSubview:imageView];
    return imageView;
}
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
                                andFrame:(CGRect)frame{
    ABABasicUIButton *button=[[ABABasicUIButton alloc]initWithFrame:frame];
    if ([btnTitle isKindOfClass:[NSString class]]) {
        [button setTitle:[NSString stringWithFormat:@"%@",btnTitle] forState:UIControlStateNormal];
    }
    if([titleColor isKindOfClass:[UIColor class]]){
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }else{
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
    if (superView) {
        [superView addSubview:button];
    }
    if (fontSize > 0 && fontSize < CGRectGetHeight(frame)) {
        button.titleLabel.font = JY_Font_Sys(fontSize);
    }else if (fontSize > CGRectGetHeight(frame)) {
        button.titleLabel.font = JY_Font_Sys(fontSize);
    }else{
        button.titleLabel.font = 0;
    }
    
    return button;
}

+ (UIControl *)initControlWithFrame:(CGRect )frame
                        andJoinView:(UIView *)superView{
    UIControl * control=[[ABABasicUIControl alloc]initWithFrame:frame];
    if (superView) {
        [superView addSubview:control];
    }
    control.backgroundColor = [UIColor clearColor];
    return control;
}

/*************************UILabelKits*******************************/
/*
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
                              andJoinView:(UIView *)superView{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([labelDetail isKindOfClass:[NSString class]]) {
        [label setText:[NSString stringWithFormat:@"%@",labelDetail]];
    }
    if([titleColor isKindOfClass:[UIColor class]]){
        [label setTextColor:titleColor];
    }else{
        [label setTextColor:kBlackColor];
    }
    if (superView) {
        [superView addSubview:label];
    }
    if (fontSize > 0 && fontSize <= CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else if (fontSize > CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else{
        label.font = 0;
    }
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
/**
 *  按钮初始化
 *  @param labelDetail 按钮标题
 *  @param titleColor 按钮标题颜色
 *  @param font 标题大小
 *  @param superView 父视图
 *  @param maxWidth 最大宽度
 */
+ (UILabel *) initLabelViewWithAutoSizeWithLabelDetail:(NSString *)labelDetail
                                        withLabelColor:(UIColor *)titleColor
                                              withFont:(UIFont *)font
                                          withFontSize:(float)fontSize
                                        withLabelFrame:(CGRect )frame
                                          withMaxWidth:(CGFloat)maxWidth
                                          withJoinView:(UIView *)superView{
    if (maxWidth == 0) {
        maxWidth = JYScreenW;
    }
    CGFloat width = [WDLUsefulKitModel stringSize:labelDetail font:font width:maxWidth].width;
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([labelDetail isKindOfClass:[NSString class]]) {
        [label setText:[NSString stringWithFormat:@"%@",labelDetail]];
    }
    if([titleColor isKindOfClass:[UIColor class]]){
        [label setTextColor:titleColor];
    }else{
        [label setTextColor:kBlackColor];
    }
    if (superView) {
        [superView addSubview:label];
    }
    label.font = font;
    if (font > 0 && fontSize <= CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else if (fontSize > CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else{
        label.font = 0;
    }
    [label setWidth:width];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
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
                                          andJoinView:(UIView *)superView{
    if (maxWidth == 0) {
        maxWidth = JYScreenW;
    }
    CGFloat width = [WDLUsefulKitModel stringSize:labelDetail font:JY_Font_Sys(fontSize) width:maxWidth].width;
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([labelDetail isKindOfClass:[NSString class]]) {
        [label setText:[NSString stringWithFormat:@"%@",labelDetail]];
    }
    if([titleColor isKindOfClass:[UIColor class]]){
        [label setTextColor:titleColor];
    }else{
        [label setTextColor:kBlackColor];
    }
    if (superView) {
        [superView addSubview:label];
    }
    if (fontSize > 0 && fontSize <= CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else if (fontSize > CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else{
        label.font = 0;
    }
    [label setWidth:width];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
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
                              andJoinView:(UIView *)superView{
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([labelDetail isKindOfClass:[NSString class]]) {
        [label setText:[NSString stringWithFormat:@"%@",labelDetail]];
    }
    if([titleColor isKindOfClass:[UIColor class]]){
        [label setTextColor:titleColor];
    }else{
        [label setTextColor:kBlackColor];
    }
    if (superView) {
        [superView addSubview:label];
    }
    if (fontSize > 0 && fontSize <= CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else if (fontSize > CGRectGetHeight(frame)) {
        label.font = JY_Font_Sys(fontSize);
    }else{
        label.font = 0;
    }
    if (alignmentType == 0) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if (alignmentType == 1){
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentRight;
    }
    
    return label;
}


+ (UITextView *)initTextViewWithPlaceholder:(NSString *)placeholder
                              andTextColor:(UIColor *)titleColor
                               andTextFont:(float )fontSize
                                   andFrame:(CGRect )frame
                                andJoinView:(UIView *)superView{
    //方法的实现部分（记得导入头文件"UITextView+Placeholder.h"）
    UITextView * contentTextView = [[UITextView alloc] initWithFrame:frame];
    if (titleColor != nil) {
        contentTextView.textColor = titleColor;
    }
    if (fontSize > 0) {
        contentTextView.font = JY_Font_Sys(fontSize);
    }

    if (superView != nil) {
        [superView addSubview:contentTextView];
    }
    return contentTextView;
}
/*************************UITextFieldKits*******************************/
/**
 *  按钮初始化
 *  @param placeholder 提示文字
 *  @param titleColor 按钮标题颜色
 *  @param fontSize 标题大小
 *  @param superView 父视图
 */
+ (UITextField *)initTextfieldViewWithPlaceholder:(NSString *)placeholder
                                   andLabelColor:(UIColor *)titleColor
                                    andLabelFont:(float )fontSize
                                        andFrame:(CGRect )frame
                                     andJoinView:(UIView *)superView{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    
    if ([placeholder isKindOfClass:[NSString class]]) {
        [textField setPlaceholder:[NSString stringWithFormat:@"%@",placeholder]];
    }
    textField.placeholder =placeholder;
    textField.font = JY_Font_Sys(fontSize);
    if([titleColor isKindOfClass:[UIColor class]]){
        [textField setTextColor:titleColor];
    }else{
        [textField setTextColor:kBlackColor];
    }
    [textField setValue:JYPlaceHolderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    if (superView) {
        [superView addSubview:textField];
    }
    return textField;
}


/*************************画直线*******************************/

+ (UIView *)initializeViewLineWithFrame:(CGRect ) aFrame
                            andJoinView:(UIView *)superView
{
    UIView * lineView = [[UIView alloc]initWithFrame:aFrame];
    lineView.frame = aFrame;
    if (superView) {
        [superView addSubview:lineView];
    }
    return lineView;
}

+ (CALayer *)getLayerLineWithFrame:(CGRect ) aFrame
                       andJoinView:(UIView *)superView
{
    CALayer * lineLayer = [CALayer layer];
    lineLayer.backgroundColor = JYLineColor.CGColor;
    lineLayer.frame = aFrame;
    if (superView) {
        [superView.layer addSublayer:lineLayer];
    }
    return lineLayer;
}
+ (UIView *)getViewLineWithFrame:(CGRect ) aFrame
                     andJoinView:(UIView *)superView
{
    UIView * lineView = [[UIView alloc]initWithFrame:aFrame];
    lineView.backgroundColor = JYLineColor;
    lineView.frame = aFrame;
    if (superView) {
        [superView addSubview:lineView];
    }
    return lineView;
}
@end
