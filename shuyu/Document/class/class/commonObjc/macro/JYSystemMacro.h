//
//  JYSystemMacro.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#ifndef JYSystemMacro_h
#define JYSystemMacro_h

#define SafeAreaBottomHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 34 : 0)
#define SafeAreaTopHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 88 : 64)
#define SafeNaviTopHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 24 : 0)
#define SafeTabbarBottomHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 83 : 49)
#define StatusBarHeight (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 44 : 20)
#define JYStatusBarHeight        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define JYNavigationBarHeight    ([GlobalVariables sharedInstance].appNavigationBarHeight ? : self.navigationController.navigationBar.frame.size.height)
#define JYTabBarHeight           ([GlobalVariables sharedInstance].appTabBarHeight ? : self.tabBarController.tabBar.frame.size.height)



#define JYWeakify(objc)                __weak  typeof(self) weakSelf = objc;
#define JYStrongify(objc)              __strong typeof(self) strongSelf = objc;
#define JYGetWeakSelf(objc)            __block __weak typeof(objc) weakSelf = objc;


#define JYIsiPhoneX (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? YES : NO)

//获取屏幕参数
#define JYScreenFrame            [UIScreen mainScreen].bounds
#define JYScreenBounds           [UIScreen mainScreen].bounds
#define JYScreenSize             [UIScreen mainScreen].bounds.size
#define JYScreenScale            [UIScreen mainScreen].scale
#define JYScreenW                [[UIScreen mainScreen] bounds].size.width
#define JYScreenH                [[UIScreen mainScreen] bounds].size.height
#define JYScaleW                 (JYScreenW)*(JYScreenScale)
#define JYScaleH                 (JYScreenH)*(JYScreenScale)

#define JYScale_Width            [[UIScreen mainScreen] bounds].size.width/375.00
#define JYScale_Height           [[UIScreen mainScreen] bounds].size.height/667.00

// 主窗口的宽、高
#define JYMainScreenWidth    MainScreenWidth()
#define JYMainScreenHeight   MainScreenHeight()

static __inline__ CGFloat MainScreenWidth()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

static __inline__ CGFloat MainScreenHeight()
{
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width;
}


//自定义高效率的 NSLog
#ifdef DEBUG
#define WDLLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define WDLLog(...)

#endif

#define JYCodingImplementation \
- (instancetype)initWithCoder:(NSCoder *)aDecoder\
{\
if (self = [super init]) {\
[self wy_decode:aDecoder];\
}\
return self;\
}\
- (void)encodeWithCoder:(NSCoder *)aCoder\
{\
[self wy_encode:aCoder];\
}
#define JYGetStrongSelf(objc) __block __weak typeof(objc) strongSelf = objc;JYGetVersion(objc);

#define  JYAdjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)





#endif /* JYSystemMacro_h */
