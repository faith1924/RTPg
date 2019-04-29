//
//  MouseItemView.h
//  HitMouse_Project
//
//  Created by Rainy on 2018/4/18.
//  Copyright © 2018年 WealthOnline_iOS_team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class pigView;

@protocol MouseItemViewDelegate <NSObject>

- (void)hitMouse:(pigView *)mouseItem;

@end

@interface pigView : UIView

@property(nonatomic,weak)id<MouseItemViewDelegate> delegate;

- (void)mouseOutHole;
- (void)mouseInHole;

@end
