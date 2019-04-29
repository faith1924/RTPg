//
//  ABAShareAlertView.m
//  ABCMobileProject
//
//  Created by mylm on 2018/12/20.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "ABAShareAlertView.h"

@implementation ABAShareAlertView
+ (instancetype)shareView{
    static ABAShareAlertView * view = nil;
    static dispatch_once_t once;;
    dispatch_once(&once, ^{
        view = [[ABAShareAlertView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, JYScreenH)];
        view.backgroundColor = RGBAOF(0x000000, 0.2);
        view.layer.masksToBounds = YES;
        view.alpha = 0;
        [view initConfi];
        [WDLGetKeyWindow addSubview:view];
    });
    return view;
}
- (void)initConfi{
    [self addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
}
- (void)hiddenView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    if (self) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        }];
    }
}
- (void)show{
    if (self) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        }];
    }
}
@end
