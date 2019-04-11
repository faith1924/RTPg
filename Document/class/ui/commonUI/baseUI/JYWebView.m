//
//  JYWebView.m
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYWebView.h"

@implementation JYWebView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame configuration:(nonnull WKWebViewConfiguration *)configuration{
    if (self = [super initWithFrame:frame configuration:configuration]) {
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
