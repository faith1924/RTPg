//
//  JYUINavigationBar.m
//  ABCMobileProject
//
//  Created by mmy on 2018/7/5.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "JYUINavigationBar.h"

#define leftTag 16000
#define leftOtherTag 16010

#define rightTag 16100
#define rightOtherTag 16110


#define kitHeight 46
#define kitWidth 50
#define bgColor JYBlueColor

@interface JYUINavigationBar ()
@property (strong , nonatomic) UIView * navigationBackBtn;;
@property (strong , nonatomic) UIView * navigationItemRightView;
@property (strong , nonatomic) UIView * navigationItemLeftView;
@end
@implementation JYUINavigationBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, JYScreenW, SafeAreaTopHeight)]) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.navigationItemRightView];
        [self addSubview:self.navigationItemLeftView];
        [self addSubview:self.lineView];
        
        //返回按钮
        [self.navigationItemLeftView addSubview:self.navigationBackBtn];
        [self setIsShowBack:NO];
    }
    return self;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [JYCommonKits getViewLineWithFrame:CGRectMake(0, SafeAreaTopHeight - 0.5, JYScreenW, 0.5) andJoinView:nil];
    }
    return _lineView;
}
-(void)setIsShowBack:(BOOL)isShowBack{
    _isShowBack = isShowBack;
    _navigationBackBtn.hidden = !_isShowBack;
}
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _titleLabel.centerX = self.width/2;
    _titleLabel.centerY = SafeAreaTopHeight - kitHeight/2;
}
- (UIView *)navigationItemLeftView{
    if (!_navigationItemLeftView) {
        _navigationItemLeftView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, self.height - kitHeight, JYScreenW/2, kitHeight) andJoinView:self];
        UIControl * control = nil;
        for (int x = 0; x < 3; x++) {
            control = [JYCommonKits initControlWithFrame:CGRectMake(kitWidth * x, 0, kitWidth, _navigationItemLeftView.height) andJoinView:_navigationItemLeftView];
            control.tag = leftTag + x;
        }
    }
    return _navigationItemLeftView;
}
- (UIView *)navigationItemRightView{
    if (!_navigationItemRightView) {
        _navigationItemRightView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(JYScreenW/2, self.height - kitHeight, JYScreenW/2, kitHeight) andJoinView:self];
        UIControl * control = nil;
        for (int x = 0; x < 3; x++) {
            control = [JYCommonKits initControlWithFrame:CGRectMake(_navigationItemRightView.width-kitWidth * (x+1), 0, kitWidth, _navigationItemRightView.height) andJoinView:_navigationItemRightView];
            control.tag = rightTag + x;
        }
    }
    return _navigationItemRightView;
}
- (void)setBtnWithImageArr:(NSArray<NSString *> *)imageArr
              withDelegate:(id)delegate
             withActionArr:(NSArray *)selArr
                    isLeft:(BOOL)flag{
    NSInteger count = MIN(imageArr.count, selArr.count);
    count = MIN(3, count);
    UIControl * control = nil;
    UIImageView * imageView = nil;
    UIImage * image = nil;
    SEL seletor = nil;
    NSInteger tag = 0;
    NSInteger imageTag = 0;
    if (flag == YES) {
        tag = leftTag;
        imageTag = leftOtherTag;
    }else{
        tag = rightTag;
        imageTag = rightOtherTag;
    }
    for (int x = 0; x < count; x++) {
        control = [self viewWithTag:tag];
        seletor = NSSelectorFromString(selArr[x]);
        [control addTarget:delegate action:seletor forControlEvents:UIControlEventTouchUpInside];
        [control.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        image = [UIImage imageNamed:imageArr[x]];
        imageView = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) AndSuperView:control AndImage:image];
        imageView.center = CGPointMake(control.width/2, control.height/2);
        imageView.tag = imageTag + x;
        tag++;
    }
}
- (void)setBtnWithTitleArr:(NSArray<NSString *> *)titleArr
         withTitleColorArr:(NSArray <UIColor *>*)titleColorArr
              withDelegate:(id)delegate
             withActionArr:(NSArray *)selArr
                    isLeft:(BOOL)flag{
    NSInteger count = MIN(titleArr.count, selArr.count);
    count = MIN(3, count);
    UIControl * control = nil;
    UILabel * label = nil;
    SEL seletor = nil;
    NSInteger tag = 0;
    NSInteger labelTag = 0;
    if (flag == YES) {
        tag = leftTag;
        labelTag = leftOtherTag;
    }else{
        tag = rightTag;
        labelTag = rightOtherTag;
    }
    for (int x = 0; x < count; x++) {
        control = [self viewWithTag:tag];
        seletor = NSSelectorFromString(selArr[x]);
        [control addTarget:delegate action:seletor forControlEvents:UIControlEventTouchUpInside];
        [control.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        label = [JYCommonKits initLabelViewWithLabelDetail:WDLTurnIdToString(titleArr[x])
                                           andTextAlignment:1
                                              andLabelColor:(titleColorArr[x]==nil?JYDeepColor:titleColorArr[x])
                                               andLabelFont:16
                                              andLabelFrame:CGRectMake(0, 0, control.width, control.height)
                                                andJoinView:control];
        label.tag = labelTag + x;
        tag++;
    }
}
//获取按钮
- (UIImageView *)getImageViewWithIndex:(int)index isLeft:(BOOL)flag{
    if (flag == YES) {
        return [self.navigationItemLeftView viewWithTag:index+leftOtherTag];
    }else{
        return [self.navigationItemRightView viewWithTag:index+rightOtherTag];
    }
}

- (UIView *)navigationBackBtn{
    if (!_navigationBackBtn) {
        _navigationBackBtn = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, kitWidth, _navigationItemLeftView.height) andJoinView:nil];
        
        UIControl * control = [JYCommonKits initControlWithFrame:CGRectMake(0, 0, kitWidth, kitHeight) andJoinView:_navigationBackBtn];
        [control addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchDown];
        
        UIImageView * backImage = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, 0, 18*JYScale_Width, 18*JYScale_Width) AndSuperView:_navigationBackBtn];
        [backImage setImage:[UIImage imageNamed:@"back_btn_blue"]];
        backImage.center = control.center;
    }
    return _navigationBackBtn;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight - kitHeight, 100, kitHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font =  JY_Font_Sys(NgBarTitleSize*JYScale_Height);
        _titleLabel.textColor = JYDeepColor;
        _titleLabel.center = CGPointMake(JYScreenW/2, _titleLabel.center.y);
    }
    return _titleLabel;
}
- (void)setImage:(NSString *)key
     withisImage:(BOOL)isImage
         isRight:(BOOL)flag
       withIndex:(NSInteger)index{
    UIControl * control = nil;
    UILabel * label = nil;
    UIImageView * imageView = nil;
    UIImage * image = nil;
    NSInteger btnTag = 0;
    NSInteger otherTag = 0;
    if (flag == YES) {
        btnTag = rightTag + index;
        otherTag = rightOtherTag;
    }else{
        btnTag = leftTag + index;
        otherTag = leftOtherTag;
    }
    control = [self viewWithTag:btnTag];
    [control.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (isImage) {
        image = [UIImage imageNamed:key];
        imageView = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, 0, image.size.width, image.size.height) AndSuperView:control AndImage:image];
        imageView.center = CGPointMake(control.width/2, control.height/2);
        imageView.tag = otherTag + index;
    }else{
        label = [JYCommonKits initLabelViewWithLabelDetail:key
                                           andTextAlignment:1
                                              andLabelColor:kBlackColor
                                               andLabelFont:16
                                              andLabelFrame:CGRectMake(0, 0, control.width, control.height)
                                                andJoinView:control];
        label.tag = otherTag + index;
    }
}
- (void)rightAction:(UIControl *)control{
    if (self.clickBtn) {
        self.clickBtn(nil);
    }
}
- (void)leftAction:(UIControl *)control{
    if (self.clickBtn) {
        self.clickBtn(nil);
    }
}
- (void)popView{
    [[WDLUsefulKitModel getCurrentViewController].navigationController popViewControllerAnimated:YES];
}
@end
