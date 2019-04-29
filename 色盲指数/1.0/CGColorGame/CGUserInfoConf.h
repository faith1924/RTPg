//
//  CGUserInfoConf.h
//  CGColorGame
//
//  Created by md212 on 2019/4/19.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CGUserInfoConf : NSObject

@property (strong , nonatomic) NSString * conf;

@property (assign , nonatomic) BOOL status;

@property (strong , nonatomic) NSString * thumb;

+ (BOOL)get_User_Info_Status:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
