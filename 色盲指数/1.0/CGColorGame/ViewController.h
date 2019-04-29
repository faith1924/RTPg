//
//  ViewController.h
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *smallFish;
@property (weak, nonatomic) IBOutlet UIButton *oldFish;
@property (weak, nonatomic) IBOutlet UIButton *topPlayer;
@property (weak, nonatomic) IBOutlet UILabel *lastScore;
@property (weak, nonatomic) IBOutlet UILabel *bestScore;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
