//
//  WDLUsefulKitModel.h
//  chengTingApp
//
//  Created by atts on 16/7/15.
//  Copyright © 2016年 atts. All rights reserved.
//
/**
 *  一些常用公共控件初始化
 */
#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "HSUpdateApp.h"

@interface WDLUsefulKitModel : NSObject
//uilabel显示不同的颜色
+ (void)labelShowDifColorKey:(NSString *)key
                  frontColor:(UIColor *)fcolor
                   lastColor:(UIColor *)lColor
                       fSize:(float)fz
                    lastSize:(float)lz
                         lab:(UILabel *)lab;
//字典转url
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict;
//url转字典
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr;
//获取相对位置
+ (CGRect)getConvertPositionWithView:(UIView *)view withRelative:(UIView *)relativeView;
/**
 * 网络监测
 */
+ (void)networkStateChange:(void(^)(BOOL netStatus))netStatusChange;
+ (BOOL)getNetwordStatus;

/**
 *判断上个页面是否为某个类型的页面
 */
+ (BOOL)getLastViewControllerWithClass:(NSString *)viewControllerClass;

/**
 *跳转到指定页面
 */
+ (void)popToTargetViewController:(NSString *)viewControllerClass;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect andMaxWidth:(float)maxWidth;
/**
 *根据图片大下 返回相关比例图片
 */
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size;
/**
 *根据图片大下 返回相关比例图片
 */
+ (UIImage *)scaleImageFromImage:(UIImage *)image withMaxCgSize:(CGSize)size;

/**
 *  NSString转换成NSMutableAttributedString
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+ (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
                                                           text:(NSString *)text;
/**
 *  根据文字内容动态计算UILabel宽高
 *  @param maxWidth label宽度
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+ (CGSize)boundingRectWithWidth:(CGFloat)maxWidth
                  withTextFont:(UIFont *)font
               withLineSpacing:(CGFloat)lineSpacing
                          text:(NSString *)text;

/**
 *   隐藏导航栏下划线
 */
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;
/**
 *   显示导航栏下划线
 */
+ (UIImageView *)showImageViewUnder:(UIView *)view;
/**
 *   把剩余描述转成剩余时间
 */
+ (NSString *)transferRemainTimeToZHString:(long)time witType:(int) type;//0表示返回至小时 1分钟 2秒

/**
 *   返回时间戳跟当前时间做比较
 */
+ (NSString *)timeStampToZHString:(long)time witType:(int) type;//0表示返回至小时 1分钟 2秒
/**
 *   获取传入时间于当前时间的时间戳差
 */
+ (double long)getTimeStampDistanceToFromTime:(long int)time;
/**
 *   获取标准格式的剩余时间
 */
+ (NSString *)timeStampToEnString:(long int)time;

/**
 *   把long时间戳转成剩余时间
 */
+ (NSString *)changeRemainTimeToString:(long int)time;

/**
 *   替换导航栏左侧按钮
 *
 *
 */
+ (void)insteadOfLeftBtnWithType:(int)type
                            andSeletor:(SEL)selectMethor
               andTargetViewController:(UIViewController *)vc
                               andPath:(NSString *)path;

//替换导航栏右侧按钮

//替换导航栏标题界面


//添加返回手势
+(void)addBackSwapWithView:(UIView *)swapView;
//判断是否八位以上 包含数字字母
+(void)judgePassWordLegal:(NSString *)pass andPasswordType:(int)passwordType andBlock:(void(^)(BOOL status,NSString * result))completeBlock;
/**
 *  设置坐标
 *
 */
+ (CGRect)setNewFrameWithFrame:(CGRect)oldFrame
                          OriX:(CGFloat )oriX
                       andOriY:(CGFloat)oriY
                      andSizeW:(CGFloat)sizeW
                      andSizeH:(CGFloat)sizeY;

//获取字段长度
+(CGSize)stringSize:(NSString*)str font:(UIFont*)aFont width:(float)width;
+ (CGSize) heightForString:(NSString *)value andWidth:(float)width;
//获取属性名
+ (NSArray*)getPropertieNamesByObject:(id)object;
//添加动画
+ (void)addAnimationsFrom:(float)beginAlpha toAnimations:(float)endAlpha andView:(UIView *)targitView;
//y中心点转换
+ (CGPoint)setPointView:(UIView *)pointView andSetView:(UIView *)setView;
//时间戳转换时间
+ (NSString *)timeFormatter:(id)time withFormatter:(NSString *)formatter;
//时间戳 时间转换
+ (NSString *)timeChange:(id )time;

//时间转时间戳
+ (NSString *)stringTurnFormatter:(NSDate *)date;
//时间戳转时间
+ (NSString *)formatterTurnDate:(NSString *)timeString;
//带格式转换
+ (NSString *)formatterTurnDate:(NSString *)timeString withFormatter:(NSString *)formatterString;
//保存成功之类的
+ (void)showSuccessAlert:(NSString *)title;

//获取当前正在显示的控制器
+ (UIViewController *)getCurrentVC;

//获取当前正在显示的控制器
+ (UIViewController *)getCurrentViewController;

//带按钮的警告框
+ (void)showShortTitle:(NSString *)title WithButton:(NSString *)string;

//隐藏警告框
+ (void)hiddenAlert;
/**
 * 数据请求
*/

//不带提示框
+ (void)downloadMessageWithOutHud:(NSMutableDictionary *)params andInterfaceType:(NSString *)interfaceUrl andComblock:(void (^)(id))comBlock;
/**
 *  提示警告框
 */
+ (void)showAlertView:(NSString *)title;
/**
 *  加载中
 */
+ (void)showLoadingState:(NSString *)title;

/**
 *  @return scrollview
 */
+ (UIScrollView *)initializeScrollViewlWith:(CGRect )frame andView:(UIView *)superView andColor:(UIColor *)color;
/**
 *  @return control
 */
+ (UIControl *)initializeControlWithAndFrame:(CGRect )frame
                                andSuperView:(UIView *)superView;

/**
 按钮初始化：
 */

+(UIButton *)initBtnWithTitle:(NSString *)title
                andTitleColor:(UIColor *)titleColor
                 andTitleFont:(float)titleFont
                 andSuperView:(UIView *)superView
                     andFrame:(CGRect)frame;

/**
 警告框
 */
+ (MBProgressHUD *)showMBProgressHUD:(NSString *)title;
+ (void)hiddenMBProgressHUD;
+ (MBProgressHUD *)showMBProgressHUDWithoutAllScreen:(NSString *)title;
/**
 *图片初始化；
*/
+(UIImageView *)initializeImageViewWithImagePath:(NSString *)pathResource
                                        andFrame:(CGRect )frame
                                    andSuperView:(UIView *)superView;
/**
 *  标签初始化
 */
+(UILabel *)initializeLabelViewWithTitle:(NSString *)title
                                        andFrame:(CGRect )frame
                                    andSuperView:(UIView *)superView;

+ (UILabel *)initializeLabelViewWithTitle:(NSString *)title
                                 andFrame:(CGRect )frame
                             andSuperView:(UIView *)superView
                                  andFont:(float )fontHeight;
/**
 *  UITEXTField初始化
 */
+(UITextField *)initializeTextfieldViewWithPlaceholder:(NSString *)placeholder
                                    andFrame:(CGRect )frame
                                andSuperView:(UIView *)superView;

//字典转成字符串
+ (NSString *)dictionaryTurnString:(NSMutableDictionary *)dictionary;
//
/**
 *  需要返回的class
 *
 *  @param myView    获取的父视图
 *  @param viewClass 从父视图获取的子视图类型
 *
 *  @return 返回子视图
 */
+ (instancetype)checkView:(UIView *)myView andClass:(NSString*)viewClass;

/**
 *  划线
 *
 *  @param frame 线的坐标
 *  @param view  父视图
 *  @param color 线的颜色
 *
 *  @return 返回线
 */
+ (UIView *)creatBlankLine:(CGRect )frame andView:(UIView *)view andColor:(UIColor *)color;

/**
 *  获取子视图的控制器
 *
 *  @param myView 子视图
 *
 *  @return 返回控制器
 */
+(UIView *)getSuperView:(UIView *)myView;

/**
 *  rgb转图片
 */
+ (UIImage *) ImageWithColor: (UIColor *) color frame:(CGRect)aFrame;

//获取当前显示的viewcontrol
+(UIViewController *)topViewController;

/**
 * 获取界面指定父界面
 * @param classString 返回的页面类型
 * @param childView  自页面
 *  @return 返回指定父视图类型
 */

+ (id)getSuperClass:(UIView *)childView andClass:(NSString *)classString;

//检查版本
+ (void)checkCameraPermission;

//检查版本
+ (void)checkVersion;
+ (BOOL)version:(NSString *)_oldver lessthan:(NSString *)_newver;


//画虚线
+ (void)drawDottedLineWithLayer:(CALayer *)layer
                 withLineHeight:(CGFloat)height
                      withColor:(UIColor *)color
                  withLineWidth:(CGFloat)width
                       witSpace:(CGFloat)space
                 withBeginFrame:(CGPoint)beginFrame
                   withEndFrame:(CGPoint)endFrame;
//获取uitextView长度
+ (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView;
//移除界面
+ (void)removeAllSubviewsWithSuperView:(UIView *)view;
//拼接数组字符串
+ (NSString *)JoinStringWithArr:(NSMutableArray *)arr;
//获取字体属性配置
+ (NSMutableAttributedString *)getAttributedStringWithContent:(NSString *)content withFont:(UIFont *)font;
//获取label最大行数
+ (NSMutableArray *)getSeparatedLinesFromString:(NSString *)text withFont:(UIFont *)font withWidth:(float)width withAttribute:(NSMutableAttributedString *)attStr;
@end
