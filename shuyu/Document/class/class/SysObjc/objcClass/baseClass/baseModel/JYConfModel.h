//
//  JYConfModel.h
//  RTPg
//
//  Created by md212 on 2019/4/16.
//  Copyright © 2019年 tts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYBasicModel.h"
#import "AVOSCloud.h"

NS_ASSUME_NONNULL_BEGIN

@interface JYConfModel : JYBasicModel

@property (strong , nonatomic) NSString <Optional>* __type;

@property (strong , nonatomic) NSString <Optional>* thumbImg;

@property (strong , nonatomic) NSString <Optional>* className;

@property (strong , nonatomic) NSString <Optional>* username;

@property (strong , nonatomic) NSString <Optional>* password;

@property (strong , nonatomic) NSDictionary <Optional>* createdAt;

@property (strong , nonatomic) NSString <Optional>* email;

@property (strong , nonatomic) NSString <Optional>* emailVerified;

@property (strong , nonatomic) NSString <Optional>* mobilePhoneVerified;

@property (strong , nonatomic) NSString <Optional>* objectId;

@property (strong , nonatomic) NSString <Optional>* sessionToken;

@property (strong , nonatomic) NSDictionary <Optional>* updatedAt;

@property (strong , nonatomic) NSError <Optional>* error;

@property (strong , nonatomic) AVUser <Optional>* user;

//获取app登录状态
-(BOOL)getLoginStatus;
-(void)setLoginStatus:(BOOL)loginStatus;

@end

NS_ASSUME_NONNULL_END
