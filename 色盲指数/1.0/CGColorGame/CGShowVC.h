//
//  CGShowVC.h
//  ColorGame
//
//  Created by cyg on 15/12/31.
//  Copyright © 2015年 cyg. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ColorGamePlayType) {
    CGGameTypeLimitTotalTime,
    CGGameTypeLimitSingleStageTime
};

typedef NS_ENUM(NSInteger, CGgameLevel) {
    CGgameLevelEase,
    CGgameLevelNormal,
    CGgameLevelHard
};

typedef NS_ENUM(NSInteger, CBlindLevel) {
    CBlindLevel1,
    CBlindLevel2,
    CBlindLevel3,
    CBlindLevel4,
    CBlindLevel5
};

@interface CGShowVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, assign) ColorGamePlayType colorGamePlayType;//两种玩法
@property (assign , nonatomic) CGgameLevel level;
@end
