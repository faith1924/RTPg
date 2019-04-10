//
//  LeanCloudResModel.h
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 蚂蚁区块链联盟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeanCloudResModel : NSObject

@property (strong , nonatomic) NSError * error;

@property (strong , nonatomic) NSMutableDictionary * result;

@property (assign , nonatomic) BOOL status;

@property (strong , nonatomic) AVUser * user;

@end

NS_ASSUME_NONNULL_END
