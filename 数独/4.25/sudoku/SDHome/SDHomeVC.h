//
//  SDHomeVC.h
//  sudoku
//
//  Created by md212 on 2019/4/24.
//  Copyright © 2019年 com/qianfeng/mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int ,levelType){
    easyLev,
    midLev,
    hardLev
};

@interface SDHomeVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLal;

@property (weak, nonatomic) IBOutlet UIButton *EasyLev;

@property (weak, nonatomic) IBOutlet UIButton *MiddleLev;

@property (weak, nonatomic) IBOutlet UIButton *HardLev;

@property (strong , nonatomic) void (^ClickIndex)(levelType index);

@property (weak, nonatomic) IBOutlet UILabel *lastScore;

@property (weak, nonatomic) IBOutlet UILabel *bestScore;

@end

NS_ASSUME_NONNULL_END
