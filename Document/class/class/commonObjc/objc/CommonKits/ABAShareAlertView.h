//
//  ABAShareAlertView.h
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/12/20.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ABAShareAlertView : UIControl
+ (instancetype)shareView;
- (void)hiddenView;
- (void)show;
@end
NS_ASSUME_NONNULL_END
