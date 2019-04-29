//
//  ABAShareAlertView.h
//  ABCMobileProject
//
//  Created by mylm on 2018/12/20.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ABAShareAlertView : UIControl
+ (instancetype)shareView;
- (void)hiddenView;
- (void)show;
@end
NS_ASSUME_NONNULL_END
