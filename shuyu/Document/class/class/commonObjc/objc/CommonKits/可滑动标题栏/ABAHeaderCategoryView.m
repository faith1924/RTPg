//
//  ABAHeaderCategoryView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/8/27.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABAHeaderCategoryView.h"

#define btnTag 14900

@interface ABAHeaderCategoryView (){
    UIButton * tempBtn;
}

@property (strong , nonatomic) UIView * titleView;

@end

@implementation ABAHeaderCategoryView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:56.0f/255.0f blue:133.0f/255.0f alpha:0.2f];
        [self addSubview:self.titleView];
    }
    return self;
}
-(void)setTitleArr:(NSMutableArray *)titleArr{
    if (titleArr) {
        _titleArr = titleArr;
        
        for (UIButton * btn in self.titleView.subviews) {
            if([btn isKindOfClass:[UIButton class]]){
                [btn removeFromSuperview];
            }
        }
        
        CGRect tFrame = CGRectZero;
        UIButton * button;
        float btnWidthSpace = 15*JYScale_Width;
        float btnHeightSpace = 8*JYScale_Width;
        
        float btnWidth = (JYScreenW - btnWidthSpace*5)/4;
        float btnHeight = 36*JYScale_Height;
        
        for(int x = 0; x <_titleArr.count; x++) {
            tFrame = CGRectMake((btnWidth + btnWidthSpace) * (x%4) + btnWidthSpace, (btnHeight + btnHeightSpace) * (x/4) + 20*JYScale_Height, btnWidth, btnHeight);
            button = [JYCommonKits initButtonnWithButtonTitle:WDLTurnIdToString(_titleArr[x]) andLabelColor:JYDeepColor andLabelFont:13*JYScale_Height andSuperView:_titleView andFrame:tFrame];
            button.tag = btnTag + x;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 2;
            
            [button setBackgroundImage:[UIImage imageNamed:@"classify_select"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"classify_selected"] forState:UIControlStateSelected];
        }
        
        [_titleView setHeight:CGRectGetMaxY(tFrame) + 20*JYScale_Height];
    }
}
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, 1) andJoinView:self];
        _titleView.backgroundColor = kWhiteColor;
    }
    return _titleView;
}
- (void)setButtonIndex:(NSInteger )index{
    UIButton * btn = [self viewWithTag:index + btnTag];
    [self buttonAction:btn];
}
- (void)buttonAction:(UIButton *)sender{
    if (tempBtn == sender) {
        return;
    }else{
        tempBtn.selected = NO;
        sender.selected = YES;
        tempBtn = sender;
        if (self.categoryViewDelegate && [self.categoryViewDelegate respondsToSelector:@selector(headerCategoryView:didSelectRowAtIndexPath:)]) {
            [self.categoryViewDelegate headerCategoryView:self didSelectRowAtIndexPath:(int)(sender.tag - btnTag)];
        }
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
