//
//  JYTabBarController.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYTabBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JYTabBarControllerDelegate <UITabBarControllerDelegate>

- (void)JYTabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface JYTabBarController : UITabBarController

@property (nonatomic, weak) id<JYTabBarControllerDelegate> JYDelegate;

@property (strong , nonatomic) JYTabBar * JYBar;

@property (assign , nonatomic) JYtabBarControlType type;

/**
 初始化方法

 @param type 初始化类型
 @return 返回
 */
- (instancetype)initWithTabbarType:(JYtabBarControlType)type;

@end

NS_ASSUME_NONNULL_END
