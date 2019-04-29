//
//  ABAHeaderTabView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/8/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "JYUIScrollView.h"

@class ABAHeaderTabView;
@protocol ABAHeaderTabViewDelegate <NSObject>

- (void)headerTabView:(ABAHeaderTabView *)headerTabView didSelectRowAtIndexPath:(NSInteger )indexPath;

@end

@interface ABAHeaderTabView : UIView

@property (nonatomic , weak) id <ABAHeaderTabViewDelegate> headerTabViewDelegate;

@property (strong , nonatomic) NSMutableArray * titleArr;

@property (assign , nonatomic) NSInteger defaultType;

- (void)hiddenCategoryView;
@end
