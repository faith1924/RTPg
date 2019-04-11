//
//  JYBusinessMacro.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#ifndef JYBusinessMacro_h
#define JYBusinessMacro_h

// ====================================设置一些内连函数+全局枚举==========================================

//UITabbarController初始化可选模式
typedef NS_ENUM(NSInteger, JYtabBarControlType){
    defaultModel = 0,
    defaultValue1 = 1,//中间带有按钮
};


typedef NS_ENUM(NSInteger, JYTabBarType){
    JYTabBarCenterButtonDefault,//居中
    JYTabBarCenterButtonHalf,//一半
    JYTabBarCenterButtonLittle//超过一点点
};

#define defaultImage [UIImage imageNamed:@"loadingImage"]
#define NgBarTitleSize 16
#define defaultNumberData 20
#define tableHeaderSpaceH 10


#define SUCCESS_CODE 0
#define SUCCESS_CODE_200 200

/**
 typedef NS_ENUM(NSInteger, FW_LIVE_TYPE)
 {
 FW_LIVE_TYPE_HOST               = 0,  // 直播的主播（推流）
 FW_LIVE_TYPE_RELIVE             = 1,  // 点播（回播、回看）
 FW_LIVE_TYPE_AUDIENCE           = 2,  // 直播的观众（拉流）
 FW_LIVE_TYPE_HDLIVE             = 3,  // 腾讯云互动直播（已废弃）
 FW_LIVE_TYPE_RECORD             = 4,  // 录制短视频
 };
 
 static __inline__ CGFloat BullPokerW()
 {
 CGFloat width = pokerW/(4*1.0/3.0+1);
 
 return width;
 }
 */

#endif /* JYBusinessMacro_h */
