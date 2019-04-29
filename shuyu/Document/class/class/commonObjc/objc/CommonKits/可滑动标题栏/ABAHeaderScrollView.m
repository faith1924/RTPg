//
//  ABAHeaderScrollView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/8/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABAHeaderScrollView.h"
#import "JYUIScrollView.h"
#define btnTag 15000

@interface ABAHeaderScrollView ()
@property (nonatomic , strong) JYUIScrollView * titleView;
@property (strong , nonatomic) UIView * blueLineView;
@property (strong , nonatomic) UIButton * tempBtn;
@end
@implementation ABAHeaderScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    frame.size = CGSizeMake(JYScreenW, 40*JYScale_Height);
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    if (_titleView) {
        UIButton * button = nil;
        for (int x = 0; x < _dataArr.count; x++) {
            button = [self viewWithTag:x + btnTag];
            if (button) {
                [button setTitle:WDLTurnIdToString(_dataArr[x][@"name"]) forState:UIControlStateNormal];
            }
        }
    }else{
        [self addSubview:self.titleView];
    }
}
-(void)setCurrentIndex:(int)currentIndex{
    UIButton * btn = [self viewWithTag:btnTag + currentIndex];
    if (btn) {
        [self setButtonIndex:btn];
    }
}
- (JYUIScrollView *)titleView{
    if (!_titleView) {
        _titleView = [[JYUIScrollView alloc] initWithFrame:CGRectMake(0, 0, JYScreenW, 40*JYScale_Height)];
        _titleView.scrollEnabled = YES;
        _titleView.showsVerticalScrollIndicator = NO;
        _titleView.showsHorizontalScrollIndicator = NO;

        UIButton * button;
        UIButton * firstPoint;
        CGSize size;
        CGRect tFrame = CGRectMake(0, 0, 0, 0);
        for (int x = 0; x < self.dataArr.count; x++) {
            size = [WDLUsefulKitModel stringSize:WDLTurnIdToString(_dataArr[x][@"name"]) font:JY_Font_Sys(14*JYScale_Height) width:90*JYScale_Width];
            tFrame = CGRectMake(CGRectGetMaxX(tFrame), 0, size.width + 30*JYScale_Width, CGRectGetHeight(_titleView.frame));//距离两边各15
            button = [JYCommonKits initButtonnWithButtonTitle:WDLTurnIdToString(_dataArr[x][@"name"]) andLabelColor:JYDeepColor andLabelFont:14*JYScale_Height andSuperView:_titleView andFrame:tFrame];
            [button addTarget:self action:@selector(setButtonIndex:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = btnTag + x;

            [button setTitleColor:JYDeepColor forState:UIControlStateNormal];
            [button setTitleColor:JYBlueColor forState:UIControlStateSelected];

            if (x == 0) {
                firstPoint = button;
            }
        }
        [self setButtonIndex:firstPoint];
        [_titleView setContentSize:CGSizeMake(CGRectGetMaxX(button.frame), 0)];
    }
    return _titleView;
}
- (void)setButtonIndex:(UIButton *)sender{
    [self btnSetContentOffset:sender];//更换焦点
    if (self.headerScrollViewDelegate && [self.headerScrollViewDelegate respondsToSelector:@selector(headerScrollView:didSelectRowAtIndexPath:)]) {
        [self.headerScrollViewDelegate headerScrollView:self didSelectRowAtIndexPath:(int)(sender.tag - btnTag)];
    }
}
- (void)btnSetContentOffset:(UIButton *)sender{
    if (_tempBtn == sender) {
        return;
    }else{
        _tempBtn.selected = NO;
        _tempBtn.titleLabel.font = JY_Font_Sys(14*JYScale_Height);

        sender.selected = YES;
        _tempBtn = sender;
        _tempBtn.titleLabel.font = JY_Font_Sys(16*JYScale_Height);

        JYWeakify(self);
        [UIView animateWithDuration:0.3 animations:^{
            float contentOffset = MAX((weakSelf.tempBtn.center.x - CGRectGetWidth(weakSelf.titleView.frame)/2),0);
            contentOffset = MIN(contentOffset,(weakSelf.titleView.contentSize.width - CGRectGetWidth(weakSelf.titleView.frame)));
            [weakSelf.titleView setContentOffset:CGPointMake(contentOffset,0)];
        }completion:^(BOOL finished) {

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
