//
//  LeanCloudResModel.h
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 mylm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud.h"
#import "JYConfModel.h"


@interface LeanCloudResModel : NSObject

@property (strong , nonatomic) JYConfModel * model;

@property (strong , nonatomic) NSError * error;

@property (strong , nonatomic) NSMutableArray * userArr;

@property (strong , nonatomic) NSMutableDictionary * result;

@property (strong , nonatomic) NSMutableDictionary * clientUserInfo;

@property (strong , nonatomic) AVUser * user;

//缓存到本地
@property (assign , nonatomic) BOOL status;

@property (strong , nonatomic) NSDictionary * userInfo;

+ (instancetype) shareCloudModel;

@end


