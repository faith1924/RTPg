//
//  UBDataModel.h
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 ntygdff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVOSCloud.h"



@interface UBDataModel : NSObject

@property (strong , nonatomic) NSError * error;

@property (strong , nonatomic) NSMutableArray * userArr;

@property (strong , nonatomic) NSMutableDictionary * result;

@property (strong , nonatomic) id clientUserInfo;

@property (strong , nonatomic) AVUser * user;

//缓存到本地
@property (assign , nonatomic) BOOL status;

@property (strong , nonatomic) NSDictionary * userInfo;

@property (strong , nonatomic) NSString * objectId;

@property (strong , nonatomic) NSString * thumbImg;

@property (assign , nonatomic) BOOL sex;

@property (strong , nonatomic) NSString * desc;

@property (strong , nonatomic) NSString * userid;

@property (strong , nonatomic) NSString * name;

@property (strong , nonatomic) NSString * age;

+ (instancetype) shareCloudModel;

@end


