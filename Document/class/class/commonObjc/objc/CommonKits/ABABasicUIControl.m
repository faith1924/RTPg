//
//  ABABasicUIControl.m
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/10/15.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import "ABABasicUIControl.h"

@implementation ABABasicUIControl
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (!self.clickFlag) {
        [super sendAction:action to:target forEvent:event];
        self.clickFlag = !self.clickFlag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            self.clickFlag = !self.clickFlag;
        });
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
