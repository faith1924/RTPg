//
//  JYWebViewController.h
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYWebViewController : JYBasicViewController

@property (strong , nonatomic) NSString * urlString;

@property (strong , nonatomic) NSString * shareThumbnail;

@property (strong , nonatomic) NSString * shareTitle;

@property (strong , nonatomic) NSString * shareBrief;

@end


NS_ASSUME_NONNULL_END
