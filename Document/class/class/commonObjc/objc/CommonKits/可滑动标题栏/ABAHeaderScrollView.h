//
//  ABAHeaderScrollView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/9/28.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ABAHeaderScrollView;

@protocol ABAHeaderScrollViewDelegate <NSObject>

- (void)headerScrollView:(ABAHeaderScrollView *)headerScrollView didSelectRowAtIndexPath:(int )indexPath;

@end

@interface ABAHeaderScrollView : UIView
@property (strong , nonatomic) NSMutableArray * dataArr;
@property (strong , nonatomic) NSMutableArray * titleArr;
@property (assign , nonatomic) int currentIndex;
@property (nonatomic , weak) id <ABAHeaderScrollViewDelegate> headerScrollViewDelegate;
@end

NS_ASSUME_NONNULL_END
