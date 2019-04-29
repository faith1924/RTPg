//
//  ABALoadingAlertView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/10/31.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABALoadingAlertView : UIControl
+ (ABALoadingAlertView *)shareLoadingView;
@property (assign , nonatomic) BOOL isClickHidden;
@property (assign , nonatomic) int aotuHiddenDurning;
- (void)hideLoading;
- (void)showLoading;
@end

NS_ASSUME_NONNULL_END
