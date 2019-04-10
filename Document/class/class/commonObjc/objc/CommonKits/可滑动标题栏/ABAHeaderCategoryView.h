//
//  ABAHeaderCategoryView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/8/27.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "JYUIScrollView.h"

@class ABAHeaderCategoryView;

@protocol ABAHeaderCategoryViewDelegate <NSObject>

- (void)headerCategoryView:(ABAHeaderCategoryView *)headerTabView didSelectRowAtIndexPath:(int )indexPath;

@end

@interface ABAHeaderCategoryView : UIButton
@property (weak,nonatomic) id<ABAHeaderCategoryViewDelegate>categoryViewDelegate;
@property (strong , nonatomic) NSMutableArray * titleArr;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)setButtonIndex:(NSInteger )index;
@end
