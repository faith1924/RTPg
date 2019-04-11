//
//  JYColorMacro.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#ifndef JYColorMacro_h
#define JYColorMacro_h


// ====================================取色值相关的方法==========================================
//十进制
#define RGB(r,g,b)          [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:(a)]

//十六进制
#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
blue:((float)(v & 0x0000FF))/255.0 \
alpha:a]
#define kColorWithStr(colorStr)      [UIColor colorWithHexString:colorStr]

// =====================================通用颜色=========================================

#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]
#define kRandomFlatColor    [UIColor randomFlatColor]

#define JYDeepColor [UIColor colorWithRed:0.0f/255.0f green:26.0f/255.0f blue:51.0f/255.0f alpha:1.0f]
#define JYLightColor [UIColor colorWithRed:138.0f/255.0f green:146.0f/255.0f blue:153.0f/255.0f alpha:1.0f]
#define JYMiddleColor [UIColor colorWithRed:92.0f/255.0f green:97.0f/255.0f blue:102.0f/255.0f alpha:1.0f]
#define JYPlaceHolderColor [UIColor colorWithRed:154.0f/255.0f green:163.0f/255.0f blue:171.0f/255.0f alpha:1.0f]
#define JYBlueColor [UIColor colorWithRed:29.0f/255.0f green:153.0f/255.0f blue:242.0f/255.0f alpha:1.0f]
#define JYLineColor [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f]
#define JYBgColor [UIColor colorWithRed:138.0f/255.0f green:146.0f/255.0f blue:153.0f/255.0f alpha:0.1f]
// =====================================以下为自定义色值）=========================================


#endif /* JYColorMacro_h */
