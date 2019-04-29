//
//  JYNotiMacro.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#ifndef JYNotiMacro_h
#define JYNotiMacro_h
// 通知中心
#define JYNoti_Default                        [NSNotificationCenter defaultCenter]
// 发通知参数
#define JYNoti_Post_Param(name,info)           [[NSNotificationCenter defaultCenter]postNotificationName:name object:nil userInfo:info]
// 发送通知
#define JYNotifPost(name, objc)                    [[NSNotificationCenter defaultCenter] postNotificationName:name object:objc]
// 监听通知
#define JYNotifAdd(name, methor)                     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(methor) name:name object:nil]
// 通知移除
#define JYNotifRemove()                      [[NSNotificationCenter defaultCenter] removeObserver:self]


#define AdvertisementNotification    @"newsConf"
#define JYLoginStatueChange    @"JYLoginStatueChange"
#define JYImageUploadSuccess    @"JYImageUploadSuccess"


#endif /* JYNotiMacro_h */
