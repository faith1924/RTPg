//
//  ABAHeaderTabView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/8/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABAHeaderTabView.h"
#import "JYUIScrollView.h"
#import "ABAHeaderCategoryView.h"
#define btnTag 14800

@interface ABAHeaderTabView ()<ABAHeaderCategoryViewDelegate>

@property (strong , nonatomic) ABAHeaderCategoryView * headerCategoryView;

@property (nonatomic , strong) JYUIScrollView * titleView;

@property (strong , nonatomic) UIView * blueLineView;

@property (strong , nonatomic) UIButton * tempBtn;

@property (strong , nonatomic) UIButton * dropBtn;

@end
@implementation ABAHeaderTabView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        
        CGRect tFrame = CGRectMake(JYScreenW - 40*JYScale_Width, 0,40*JYScale_Width, 40*JYScale_Height);
        _dropBtn = [JYCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:self andFrame:tFrame];
        [_dropBtn setImage:[UIImage imageNamed:@"classify_down_icon"] forState:UIControlStateNormal];
        [_dropBtn setImage:[UIImage imageNamed:@"classify_up_icon"] forState:UIControlStateSelected];
        _dropBtn.selected = YES;
        [_dropBtn addTarget:self action:@selector(showDropDown:) forControlEvents:UIControlEventTouchUpInside];
        
        _defaultType = 0;
        
        [self showDropDown:self.dropBtn];
        [self addSubview:self.titleView];
        
    }
    return self;
}
-(void)setTitleArr:(NSMutableArray *)titleArr{
    if (titleArr != nil) {
        _titleArr = titleArr;
        _headerCategoryView.titleArr = _titleArr;
        
        for (UIButton * btn in self.titleView.subviews) {
            if([btn isKindOfClass:[UIButton class]]){
                [btn removeFromSuperview];
            }
        }
        
        UIButton * button;
        UIButton * firstPoint;
        CGSize size;
        CGRect tFrame = CGRectMake(0, 0, 0, 0);
        for (int x = 0; x < _titleArr.count; x++) {
            size = [WDLUsefulKitModel stringSize:WDLTurnIdToString(_titleArr[x]) font:JY_Font_Sys(14*JYScale_Height) width:75*JYScale_Width];
            tFrame = CGRectMake(CGRectGetMaxX(tFrame), 0, size.width + 28*JYScale_Width, CGRectGetHeight(_titleView.frame));//距离两边各15
            button = [JYCommonKits initButtonnWithButtonTitle:WDLTurnIdToString(_titleArr[x]) andLabelColor:kBlackColor andLabelFont:15*JYScale_Height andSuperView:_titleView andFrame:tFrame];
            [button addTarget:self action:@selector(setButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = btnTag + x;
            
            [button setTitleColor:JYLightColor forState:UIControlStateNormal];
            [button setTitleColor:JYBlueColor forState:UIControlStateSelected];
            
            if (x == _defaultType) {
                firstPoint = button;
            }
        }
        [self setButtonIndex:firstPoint];
        [_titleView setContentSize:CGSizeMake(CGRectGetMaxX(button.frame), 0)];
    }
}
- (JYUIScrollView *)titleView{
    if (!_titleView) {
        _titleView = [[JYUIScrollView alloc] initWithFrame:CGRectMake(0, 0, JYScreenW - 40*JYScale_Height, 40*JYScale_Height)];
        _titleView.scrollEnabled = YES;
        _titleView.showsVerticalScrollIndicator = NO;
        _titleView.showsHorizontalScrollIndicator = NO;
    }
    return _titleView;
}
- (ABAHeaderCategoryView *)headerCategoryView{
    if (!_headerCategoryView) {
        CGRect tFrame = [self convertRect:self.bounds toView:WDLGetKeyWindow];
        _headerCategoryView = [[ABAHeaderCategoryView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(tFrame)+SafeAreaTopHeight, JYScreenW, JYScreenH - CGRectGetMaxY(tFrame))];
        _headerCategoryView.categoryViewDelegate = self;
        [_headerCategoryView addTarget:self action:@selector(hiddenCategoryView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerCategoryView;
}
- (void)hiddenCategoryView{
    if (_headerCategoryView.hidden == NO) {
        [self showDropDown:_dropBtn];
    }
}
- (void)showDropDown:(UIButton *)sender{
    [WDLGetKeyWindow addSubview:self.headerCategoryView];

    sender.selected = !sender.selected;
    [self.headerCategoryView.superview  bringSubviewToFront:self.headerCategoryView];
    self.headerCategoryView.hidden = !sender.selected;
    self.titleView.userInteractionEnabled = self.headerCategoryView.hidden;
    
    [self setButtonIndex:_tempBtn];
}
- (void)setButtonIndex:(UIButton *)sender{
    if (sender == nil) {
        return;
    }
    [self btnSetContentOffset:sender];
    
    NSInteger indexPath = sender.tag - btnTag;
    [self.headerCategoryView setButtonIndex:indexPath];
}
-(void)headerCategoryView:(ABAHeaderCategoryView *)headerTabView didSelectRowAtIndexPath:(int )indexPath{
    if (self.headerTabViewDelegate && [self.headerTabViewDelegate respondsToSelector:@selector(headerTabView:didSelectRowAtIndexPath:)]) {
        [self.headerTabViewDelegate headerTabView:self didSelectRowAtIndexPath:indexPath];
    }
    int index = btnTag + indexPath;
    UIButton * sender = [self.titleView viewWithTag:index];
    [self btnSetContentOffset:sender];
}
- (void)btnSetContentOffset:(UIButton *)sender{
    if (_tempBtn == sender) {
        return;
    }else{
        _tempBtn.selected = NO;
        _tempBtn.titleLabel.font = JY_Font_Sys(15*JYScale_Height);
        
        sender.selected = YES;
        _tempBtn = sender;
        _tempBtn.titleLabel.font = JY_Font_Sys(17*JYScale_Height);
        
        JYWeakify(self);
        [UIView animateWithDuration:0.3 animations:^{
            float contentOffset = MAX((weakSelf.tempBtn.center.x - CGRectGetWidth(weakSelf.titleView.frame)/2),0);
            contentOffset = MIN(contentOffset,(weakSelf.titleView.contentSize.width - CGRectGetWidth(weakSelf.titleView.frame)));
            [weakSelf.titleView setContentOffset:CGPointMake(contentOffset,0)];
        }completion:^(BOOL finished) {
            if (self.headerCategoryView.hidden == NO) {
                [self hiddenCategoryView];
            }
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
