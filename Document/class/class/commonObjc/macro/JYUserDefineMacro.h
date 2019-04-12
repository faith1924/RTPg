//
//  JYUserDefineMacro.h
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#ifndef JYUserDefineMacro_h
#define JYUserDefineMacro_h


//7.设置 view 圆角和边框
#define WDLViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//8.由角度转换弧度 由弧度转换角度
#define WDLDegreesToRadian(x) (M_PI * (x) / 180.0)
#define WDLRadianToDegrees(radian) (radian*180.0)/(M_PI)

//9.设置加载提示框（第三方框架：Toast）
#define WDLToast(str)              CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle]; \
[kWindow  makeToast:str duration:0.6 position:CSToastPositionCenter style:style];\
kWindow.userInteractionEnabled = NO; \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{\
kWindow.userInteractionEnabled = YES;\
});\

//10.设置加载提示框（第三方框架：MBProgressHUD）
// 加载
#define WDLShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
// 收起加载
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
// 设置加载
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x

#define WDLWindow [UIApplication sharedApplication].keyWindow

#define WDLBackView         for (UIView *item in WDLWindow.subviews) { \
if(item.tag == 10000) \
{ \
[item removeFromSuperview]; \
UIView * aView = [[UIView alloc] init]; \
aView.frame = [UIScreen mainScreen].bounds; \
aView.tag = 10000; \
aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
[kWindow addSubview:aView]; \
} \
} \

#define WDLShowHUDAndActivity WDLBackView;[MBProgressHUD showHUDAddedTo:kWindow animated:YES];kShowNetworkActivityIndicator()
#define WDLHiddenHUD [MBProgressHUD hideAllHUDsForView:kWindow animated:YES]
#define WDLRemoveBackView         for (UIView *item in WDLWindow.subviews) { \
if(item.tag == 10000) \
{ \
[UIView animateWithDuration:0.4 animations:^{ \
item.alpha = 0.0; \
} completion:^(BOOL finished) { \
[item removeFromSuperview]; \
}]; \
} \
} \
#define WDLHiddenHUDAndAvtivity WDLRemoveBackView;kHiddenHUD;HideNetworkActivityIndicator()


//获取view的frame/图片资源
#define WDL_CGMK(x,y,width,height) CGRectMake(x, y, width, height)
#define WDLGetViewWidth(view)  view.frame.size.width
#define WDLGetViewHeight(view) view.frame.size.height
#define WDLGetViewX(view)      view.frame.origin.x
#define WDLGetViewY(view)      view.frame.origin.y

#define RVC(vcClass)   NSArray * arr = [WDLUsefulKitModel getCurrentViewController].navigationController.viewControllers; \
NSMutableArray * controllers = [arr mutableCopy]; \
for (vcClass * controller in arr) { \
if ([controller isKindOfClass:[vcClass class]]) { \
[controllers removeObject:controller]; \
} \
} \
[[WDLUsefulKitModel getCurrentViewController].navigationController setViewControllers:controllers]; \

#define WDLTurnIdToString(a)  [NSString stringWithFormat:@"%@",a]
#define WDLTurnIntToString(a)  [NSString stringWithFormat:@"%d",a]
#define WDLTurnIntegerToString(a)  [NSString stringWithFormat:@"%ld",a]


//16.沙盒目录文件
//获取temp
#define WDLPathTemp NSTemporaryDirectory()

//获取沙盒 Document
#define WDLPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

//获取沙盒 Cache
#define WDLPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//17.GCD 的宏定义
//GCD - 一次性执行
#define WDLDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define WDLDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define WDLDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


#define GCDMain(block) dispatch_async(dispatch_get_main_queue(), block)

//GCD - 延迟调用
#define GCDMainDelay(timer,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, INT64_C(timer) * NSEC_PER_SEC), dispatch_get_main_queue(), block)

#define _po(o) DLOG(@"%@", (o))
#define _pn(o) DLOG(@"%d", (o))
#define _pf(o) DLOG(@"%f", (o))
#define _ps(o) DLOG(@"CGSize: {%.0f, %.0f}", (o).width, (o).height)
#define _pr(o) DLOG(@"NSRect: {{%.0f, %.0f}, {%.0f, %.0f}}", (o).origin.x, (o).origin.x, (o).size.width, (o).size.height)

#define PARAMS(params,key,value)  [params setObject:value forKey:key]

#define PushNewVC(VC)  VC * newViewControl = [[VC alloc]init];

#define new_ControllerWithPush(controller) controller * mine = [[controller alloc]init]; [[WDLUsefulKitModel getCurrentViewController].navigationController pushViewController:mine animated:YES];

#define new_ControllerWithOutPush(viewController) viewController * controller = [[viewController alloc]init];

#define new_Params  NSMutableDictionary * params = [[NSMutableDictionary alloc]init]

#define new_Dic(dicIdentifie) NSMutableDictionary * dicIdentifie = [[NSMutableDictionary alloc]init]

#define new_DicWithId(dicIdentifie) dicIdentifie = [[NSMutableDictionary alloc]init]

#define new_Array(arr) NSMutableArray * arr = [[NSMutableArray alloc]init]

#define CTLocalizedString(key, comment) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"本地化字符串" ofType:@"strings"]] localizedStringForKey:(key) value:@"" table:@"LocalizedString"]

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark - Check
/** 字符串是否为空*/
#define WDLStringIsEmpty(str)     ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
/** 数组是否为空*/
#define WDLArrayIsEmpty(array)    (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/** 字典是否为空*/
#define WDLDictIsEmpty(dic)       (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

/** 是否是空对象*/
#define WDLObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#pragma mark - 缩写
#define WDLGetApplication   [UIApplication sharedApplication]
#define WDLGetKeyWindow      [UIApplication sharedApplication].keyWindow
#define WDLGetWindow   [[[UIApplication sharedApplication] delegate] window]
#define WDLGetAppDelegate   ((AppDelegate*)[UIApplication sharedApplication].delegate)
#define JYGetUserDefault   [NSUserDefaults standardUserDefaults]
#define WDLNotificationCenter  [NSNotificationCenter defaultCenter]

#define WDLCenterEqualY(v1,v2) v1.center = CGPointMake(v1.center.x, v2.center.y)
#define WDLCenterEqualX(v1,v2) v1.center = CGPointMake(v2.center.x, v1.center.y)
#define WDLCenterEqual(v1,v2) v1.center = CGPointMake(v2.center.x, v2.center.y)


/** 获取沙盒 Document 路径*/
#define WDLDocumentPath       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/** 获取沙盒 temp 路径(注:iPhone 重启会清空)*/
#define WDLTempPath           NSTemporaryDirectory()
/** 获取沙盒 Cache 路径*/
#define WDLCachePath          [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
/** 获取程序包中程序路径*/
#define WDLResource(f, t)     [[NSBundle mainBundle] pathForResource:(f) ofType:(t)];
//状态栏的高度
#define WDLGetApplicationStatusBarHeight  [UIApplication sharedApplication].statusBarFrame.size.height

///------ 应用程序版本号version ------
#define WDLAppVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])

///当前日期字符串
#define DATE_STRING \
({NSDateFormatter *fmt = [[NSDateFormatter alloc] init];\
[fmt setDateFormat:@"YYYY-MM-dd hh:mm:ss"];\
[fmt stringFromDate:[NSDate date]];})


#endif /* JYUserDefineMacro_h */
