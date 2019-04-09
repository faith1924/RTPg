//
//  ABABasicUIButton.h
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/9/13.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABABasicUIButton : UIButton
@property (assign , nonatomic) BOOL clickFlag;//1的时候可以点击 0不可点击
@property (copy , nonatomic) void (^clickComplete)(void);//参数
@property (copy , nonatomic) id completeClick;//参数
@end
