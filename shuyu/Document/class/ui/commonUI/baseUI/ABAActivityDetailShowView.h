//
//  ABAActivityDetailShowView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/12/17.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYWebView.h"

NS_ASSUME_NONNULL_BEGIN
@interface ABAActivityDetailShowView : JYWebView
@property (strong , nonatomic) NSString * urlString;
@property (strong , nonatomic) NSString * htmlPath;
@property (strong , nonatomic) NSString * html;
- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)delegate;
@end

NS_ASSUME_NONNULL_END
