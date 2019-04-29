//
//  CGScoreTB.h
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGScoreTB : UITableViewController

@end

@interface CGScoreTBCell : UITableViewCell

@property (strong) UILabel * score;

@property (strong) UILabel * desc;

@end


NS_ASSUME_NONNULL_END
