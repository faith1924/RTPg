//
//  JYConfModel.m
//  RTPg
//
//  Created by md212 on 2019/4/16.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "JYConfModel.h"

@implementation JYConfModel

//获取app登录状态
-(BOOL)getLoginStatus{
    return [JYGetUserDefault boolForKey:@"loginStatus"];
}
-(void)setLoginStatus:(BOOL)loginStatus{
    [JYGetUserDefault setBool:loginStatus forKey:@"loginStatus"];
}

@end
