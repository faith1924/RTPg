//
//  JYFontMacro.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#ifndef JYFontMacro_h
#define JYFontMacro_h

// ====================================通用字体大小==========================================
#define JY_Font_Sys(x)    [UIFont systemFontOfSize:(JYIsiPhoneX?(x*((float)6/7)):x)]
//字体类型字符串
#define JY_Font_Sys_Name(font,x) [UIFont fontWithName:font size:(JYIsiPhoneX?(x*((float)6/7)):x)]

#define JY_Font_BoldOblique(x) [UIFont fontWithName:@"Helvetica-BoldOblique" size:(JYIsiPhoneX?(x*((CGFloat)6/7)):x)]
#define JY_Font_LightOblique(x) [UIFont fontWithName:@"Helvetica-LightOblique" size:(JYIsiPhoneX?(x*((CGFloat)6/7)):x)]
#define JY_Font_Light(x) [UIFont fontWithName:@"Helvetica-Light" size:(JYIsiPhoneX?(x*((CGFloat)6/7)):x)]
#define JY_Font_Bold(x) [UIFont fontWithName:@"Helvetica-Bold" size:(JYIsiPhoneX?(x*((CGFloat)6/7)):x)]

// ====================================自定义==========================================
#define JY_Font_Sys_18    [UIFont systemFontOfSize:18]
#define JY_Font_Sys_17    [UIFont systemFontOfSize:17]
#define JY_Font_Sys_16    [UIFont systemFontOfSize:16]
#define JY_Font_Sys_15    [UIFont systemFontOfSize:15]
#define JY_Font_Sys_14    [UIFont systemFontOfSize:14]
#define JY_Font_Sys_13    [UIFont systemFontOfSize:13]
#define JY_Font_Sys_12    [UIFont systemFontOfSize:12]
#define JY_Font_Sys_11    [UIFont systemFontOfSize:11]
#define JY_Font_Sys_10    [UIFont systemFontOfSize:10]








#endif /* JYFontMacro_h */
