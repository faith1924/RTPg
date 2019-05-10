//
//  easyLoginVC.h
//  RTPg
//
//  Created by tts on 2019/4/13.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface easyLoginVC : JYBasicViewController

@property (strong , nonatomic) void (^loginCom)(BOOL status);

+ (instancetype ) shareAasyLoginVC;

@end

NS_ASSUME_NONNULL_END
