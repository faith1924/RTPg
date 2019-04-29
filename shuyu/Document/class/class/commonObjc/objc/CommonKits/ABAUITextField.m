//
//  ABAUITextField.m
//  ABCMobileProject
//
//  Created by mylm on 2018/10/8.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "ABAUITextField.h"

@implementation ABAUITextField

#pragma mark - init
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // 禁用粘贴功能
    if (action == @selector(paste:))
        return NO;         // 禁用选择功能
    if (action == @selector(select:))
        return NO;            // 禁用全选功能
    if (action == @selector(selectAll:))
        return NO;
    return [super canPerformAction:action withSender:sender];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
