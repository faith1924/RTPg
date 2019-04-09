//
//  JYBasicCell.h
//  ABCMobileProject
//
//  Created by mmy on 2018/12/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBasicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYBasicCell : UITableViewCell

@property (strong , nonatomic) JYBasicModel * model;

- (void)setupUI;
@end

NS_ASSUME_NONNULL_END
