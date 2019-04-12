//
//  WDLUsefulKitModel.m
//  chengTingApp
//
//  Created by 汪栋梁 on 16/7/15.
//  Copyright © 2016年 汪栋梁. All rights reserved.
//

#import "WDLUsefulKitModel.h"
#import <objc/runtime.h>
#import "AFNetworkActivityIndicatorManager.h"
#import <AVFoundation/AVFoundation.h>

static char NSNavigationControllerWithGesKey;
static MBProgressHUD * ProgressHUD;
static UILabel * errorLabel;
static UILabel * showLabel;
static UIView *progressHudView;

@implementation WDLUsefulKitModel
//画虚线
+ (void)drawDottedLineWithLayer:(CALayer *)layer
                 withLineHeight:(CGFloat)height
                      withColor:(UIColor *)color
                  withLineWidth:(CGFloat)width
                       witSpace:(CGFloat)space
                 withBeginFrame:(CGPoint)beginFrame
                   withEndFrame:(CGPoint)endFrame{
    CAShapeLayer *dotteShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef dotteShapePath =  CGPathCreateMutable();
    //设置虚线颜色为blackColor
    [dotteShapeLayer setStrokeColor:[color CGColor]];
    //设置虚线高度
    dotteShapeLayer.lineWidth = height ;
    //10=线的宽度 5=每条线的间距
    NSArray *dotteShapeArr = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:width],[NSNumber numberWithInt:space], nil];
    [dotteShapeLayer setLineDashPattern:dotteShapeArr];
    CGPathMoveToPoint(dotteShapePath, NULL, beginFrame.x ,beginFrame.y);
    CGPathAddLineToPoint(dotteShapePath, NULL, endFrame.x, endFrame.y);
    [dotteShapeLayer setPath:dotteShapePath];
    CGPathRelease(dotteShapePath);
    //把绘制好的虚线添加上来
    [layer addSublayer:dotteShapeLayer];
}
+ (NSString *)keyValueStringWithDict:(NSDictionary *)dict
{
    if (dict == nil) {
        return nil;
    }
    NSMutableString *string = [NSMutableString stringWithString:@"?"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [string appendFormat:@"%@=%@&",key,obj];
    }];
    
    if ([string rangeOfString:@"&"].length) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    
    return string;
}

+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr
{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
//获取相对位置
+ (CGRect)getConvertPositionWithView:(UIView *)view withRelative:(UIView *)relativeView{
    return [view convertRect:view.bounds toView:relativeView];
}
/**
 *判断上个页面是否为某个类型的页面
 */
+ (BOOL)getLastViewControllerWithClass:(NSString *)viewControllerClass{
    NSArray * arr = [WDLUsefulKitModel getCurrentViewController].navigationController.viewControllers;
    long int count = arr.count;
    if (count > 2) {
        UIViewController * vc = arr[count - 2];
        if ([vc isKindOfClass:[NSClassFromString(viewControllerClass) class]]) {
            return YES;
        }
    }
    return NO;
}

/**
 * 网络监测
 */
+ (void)networkStateChange:(void(^)(BOOL netStatus))netStatusChange
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                netStatusChange(YES);
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                netStatusChange(NO);
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"手机自带网络");
                netStatusChange(YES);
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                netStatusChange(YES);
                break;
        }
    }];
    //开始监控
    [manager startMonitoring];
}
+ (BOOL)getNetwordStatus{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    // 当网络状态改变时调用
    switch (manager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown:
            return YES;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return NO;
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return YES;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return YES;
            break;
    }
    return NO;
}

/**
 *跳转到指定页面
 */
+ (void)popToTargetViewController:(NSString *)viewControllerClass{
    UINavigationController * navigation = [self getCurrentViewController].navigationController;
    for (UIViewController *vc in navigation.viewControllers) {
        if ([vc isKindOfClass:[viewControllerClass class]]) {
            [navigation popToViewController:vc animated:YES];
            break;
        }
    }
}

+ (void)checkVersion{
    [HSUpdateApp hs_updateWithAPPID:nil withBundleId:nil block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        if (isUpdate) {
            [self showAlertViewTitle:@"自动检测" subTitle:[NSString stringWithFormat:@"检测到新版本%@,是否更新？",storeVersion] openUrl:openUrl];
        }else{
            NSLog(@"当前版本%@,商店版本%@，不需要更新",currentVersion,storeVersion);
        }
    }];
}
+ (void)showAlertViewTitle:(NSString *)title subTitle:(NSString *)subTitle openUrl:(NSString *)openUrl{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:subTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            } else {
                BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            }
            
        } else{
            bool can = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:openUrl]];
            if(can){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:openUrl]];
            }
        }
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    [[self getCurrentViewController] presentViewController:alertVC animated:YES completion:nil];
}
+ (UIImage *)scaleImageFromImage:(UIImage *)image withMaxCgSize:(CGSize)size{
    CGSize imageSize = image.size;
    UIImage * newImage;
    if (imageSize.width <= size.width && imageSize.height <= size.height) {
        newImage = image;
    }else{
        float widthScale = [[NSString stringWithFormat:@"%.4f",imageSize.width/size.width] floatValue];
        float heigScale = [[NSString stringWithFormat:@"%.4f",imageSize.height/size.height] floatValue];
        float maxScale = MAX(widthScale, heigScale);
        float newWidth = [[NSString stringWithFormat:@"%.4f",imageSize.width/maxScale] floatValue];
        newImage = [self imageFromImage:image inRect:CGRectMake(0, 0, imageSize.width/maxScale, imageSize.height/maxScale) andMaxWidth:newWidth];
    }
    return newImage;
}
/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect andMaxWidth:(float)maxWidth{
    //获取图片的最大宽度
    float width = MIN(maxWidth, image.size.width);
    //获取新的比例的图片
    UIImage * newImage = [self imageCompressForWidthScale:image targetWidth:width];
    CGRect tFrame = CGRectMake(0,MAX((newImage.size.height - rect.size.height)/2, 0), newImage.size.width, newImage.size.height);
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [newImage CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, tFrame);
    
    //将CGImageRef转换成UIImage
    UIImage *newSizeImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newSizeImage;
}
//按比例缩放,size 是你要把图显示到 多大区域
+ (UIImage *) imageCompressFitSizeScale:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *按比例缩放图片
 */
+ (UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  NSString转换成NSMutableAttributedString
 *  @param font  字体
 *  @param lineSpacing  行间距
 *  @param text  内容
 */
+ (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                withLineSpacing:(CGFloat)lineSpacing
                                                           text:(NSString *)text{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:font}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail]; //截断方式，"abcd..."
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [text length])];
    return attributedStr;
}
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
                          text:(NSString *)text{
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    //段落样式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    //#warning 此处设置NSLineBreakByTruncatingTail会导致计算文字高度方法失效
    //    [paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    //计算文字尺寸
    CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    return size;
}
+ (UIImageView *)showImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        view.hidden = NO;
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        view.hidden = YES;
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
+ (NSString *)transferRemainTimeToZHString:(long)time  witType:(int) type{
    if (time <= 0) {
        return @"00:00:00";
    }
    NSString * string = @"";
    long hours = time/3600;
    NSString * hoursString = [NSString stringWithFormat:@"%ld小时",hours];;
    
    long minus = (time%3600)/60;
    NSString * minusString = [NSString stringWithFormat:@"%ld分钟",minus];
    
    long seconds = ((time%3600)%60)%60;
    NSString * secondsString = [NSString stringWithFormat:@"%ld秒",seconds];
    if (type == 0) {
        string = [NSString stringWithFormat:@"%@",hoursString];
    }else if(type == 1){
        string = [NSString stringWithFormat:@"%@%@",hoursString,minusString];
    }else if (type == 2){
        string = [NSString stringWithFormat:@"%@%@%@",hoursString,minusString,secondsString];
    }else{
        string = [NSString stringWithFormat:@"%@%@%@",hoursString,minusString,secondsString];
    }
    return string;
}
/**
 *   返回时间戳跟当前时间做比较
 */
+ (NSString *)timeStampToZHString:(long)time witType:(int) type{
    NSDate * date = [NSDate new];
    long int remainTime = [date timeIntervalSince1970];
    return [self transferRemainTimeToZHString:(time - remainTime) witType:type];
}
/**
 *   获取传入时间于当前时间的时间戳差
 */
+ (double long)getTimeStampDistanceToFromTime:(long int)time{
    NSDate * date = [NSDate new];
    long int remainTime = [date timeIntervalSince1970];
    return (time - remainTime);
}
/**
 *   获取标准格式的剩余时间
 */
+ (NSString *)timeStampToEnString:(long int)time{
    NSDate * date = [NSDate new];
    long int remainTime = [date timeIntervalSince1970];
    return [self changeRemainTimeToString:(time - remainTime)];
}
+ (NSString *)changeRemainTimeToString:(long)time{
    if (time <= 0) {
        return @"00:00:00";
    }
    long hours = time/3600;
    NSString * hoursString = @"";
    if (hours < 10) {
        hoursString = [NSString stringWithFormat:@"0%ld",hours];
    }else{
        hoursString = [NSString stringWithFormat:@"%ld",hours];
    }
    NSString * minusString = @"";
    long minus = (time%3600)/60;
    if (minus < 10) {
        minusString = [NSString stringWithFormat:@"0%ld",minus];
    }else{
        minusString = [NSString stringWithFormat:@"%ld",minus];
    }
    NSString * secondsString = @"";
    long seconds = ((time%3600)%60)%60;
    if (seconds < 10) {
        secondsString = [NSString stringWithFormat:@"0%ld",seconds];
    }else{
        secondsString = [NSString stringWithFormat:@"%ld",seconds];
    }
    NSString * string = [NSString stringWithFormat:@"%@:%@:%@",hoursString,minusString,secondsString];
    return string;
}

+ (void)insteadOfLeftBtnWithType:(int)type andSeletor:(SEL)selectMethor andTargetViewController:(UIViewController *)vc andPath:(NSString *)path{
    if (type == 0) {
        UIBarButtonItem *shareBtn= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:path] style:UIBarButtonItemStyleDone target:vc action:selectMethor];
        vc.navigationItem.rightBarButtonItem = shareBtn;
    }else if(type == 1){
        UIBarButtonItem *shareBtn= [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:path] style:UIBarButtonItemStyleDone target:vc action:selectMethor];
        vc.navigationItem.rightBarButtonItem = shareBtn;
    }
}
//添加返回手势
+(void)swipRightAction:(UISwipeGestureRecognizer *)swip{
    UINavigationController * NavigationController = (UINavigationController *)objc_getAssociatedObject(swip, &NSNavigationControllerWithGesKey);
    [NavigationController popViewControllerAnimated:YES];
}
+(void)addBackSwapWithView:(UIView *)swapView{
    UISwipeGestureRecognizer * swipRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipRightAction:)];//默认是右滑
    objc_setAssociatedObject(swipRight, &NSNavigationControllerWithGesKey, [self getCurrentViewController].navigationController, OBJC_ASSOCIATION_RETAIN);
    [swapView addGestureRecognizer:swipRight];
}

//移除界面
+ (void)removeAllSubviewsWithSuperView:(UIView *)view{
    for(UIView *vi in view.subviews){
       [vi removeFromSuperview];
    }
}

//判断是否八位以上 包含数字字母
+(void)judgePassWordLegal:(NSString *)pass andPasswordType:(int)passwordType  andBlock:(void (^)(BOOL, NSString *))completeBlock{
    NSString * resultString = @"";
    BOOL  status = false;
    if (passwordType == 0) {
        if ([pass length] != 6){
            resultString = @"密码必须为六位数字!";
            NSString *  password = [pass stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
            if(password.length > 0) {
                status = true;
                resultString = @"输入格式有误!";
            }
        }else{
            status = true;
        }
    }else{
        if ([pass length] >= 8 && [pass length] <=16){
            // 判断长度大于8位后再接着判断是否同时包含数字和字符
            BOOL result = false;
            NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            result = [pred evaluateWithObject:pass];
            status = result;
            if (status == NO) {
                resultString = @"密码输入格式有误！";
            }
        }else{
            resultString = @"8-16位(需同时包含字母与数字)";
        }
    }
    
    completeBlock(status,resultString);
}
/**
 *  设置坐标
 *
 */
+ (CGRect)setNewFrameWithFrame:(CGRect)oldFrame
                          OriX:(CGFloat )oriX
                      andOriY:(CGFloat)oriY
                     andSizeW:(CGFloat)sizeW
                     andSizeH:(CGFloat)sizeY{
    CGRect newFrame = oldFrame;
    if (oriX != 0) {
        newFrame.origin.x = oriX;
    }
    if  (oriY != 0) {
        newFrame.origin.y = oriY;
    }
    if  (sizeW != 0) {
        newFrame.size.width = sizeW;
    }
    if  (sizeY != 0) {
        newFrame.size.height = sizeY;
    }
    return newFrame;
}
+ (NSMutableArray *)getRequestArray{
    static NSMutableArray  *  array;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        array = [NSMutableArray new];
    });
    return array;
}
//判断是否有使用相机的权限
+ (void)checkCameraPermission{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted
            || authorizationStatus == AVAuthorizationStatusDenied) {
            
            // 没有权限
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
}
+ (void)addAnimationsFrom:(float)beginAlpha toAnimations:(float)endAlpha andView:(UIView *)targitView{
    if (beginAlpha<0 || beginAlpha>1) {
        beginAlpha = 0;
    }
    if(endAlpha>1||endAlpha<0){
        beginAlpha = 1;
    }
    [UIView beginAnimations:@"selfToggleViews" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (targitView.alpha == endAlpha) {
       targitView.alpha = beginAlpha;
    }else{
       targitView.alpha = endAlpha;
    }
    [UIView commitAnimations];
}
+ (CGPoint)setPointView:(UIView *)pointView andSetView:(UIView *)setView{
    CGPoint point  = pointView.center;
    point.x = setView.center.x;
    setView.center = point;
    return point;
}

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+ (NSString *)timeFormatter:(id)time withFormatter:(NSString *)formatterString{
    if([time respondsToSelector:@selector(doubleValue)]){
        NSTimeInterval interval = [time doubleValue];
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:formatterString];

        NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
        return [formatter stringFromDate:date];
    }else{
        return time;
    }
}
+ (NSString *)timeChange:(id )time
{
    NSString * timeString = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];//HH:mm:ss
    if([self isPureInt:timeString]){
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    }else {
        return timeString;
    }
}
+ (NSString *)formatterTurnDate:(NSString *)timeString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMddHHMMss"];
    NSDate * date;
    if([timeString isEqualToString:@"0"]){
        date = [NSDate date];
    }else{
        date = [formatter dateFromString:timeString];
    }
    return [NSString stringWithFormat:@"%@",date];
}

+ (NSString *)formatterTurnDate:(NSString *)timeString withFormatter:(NSString *)formatterString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterString];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate * date;
    if([timeString isEqualToString:@"0"]){
        date = [NSDate date];
    }else{
        date = [formatter dateFromString:timeString];
    }
    return [formatter stringFromDate:date];
}

+ (NSString *)stringTurnFormatter:(NSDate *)date{
     NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
     formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
     NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
//获取当前正在显示的UINavigationController
+ (UIViewController *)getCurrentViewController{
    UIViewController *vc = nil;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)window.rootViewController visibleViewController];
    }
    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController*)window.rootViewController;
        if ([[tabVC selectedViewController] isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)[tabVC selectedViewController] visibleViewController];
        }else if ([[tabVC selectedViewController] isKindOfClass:[UIViewController class]]){
            vc = [tabVC selectedViewController];
        }
    }
    else
    {
        vc = window.rootViewController;
    }
    return vc;
}

+ (void)showShortTitle:(NSString *)title WithButton:(NSString *)string{
    UIViewController *viewcontrol = [self getCurrentVC];
    if([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:@"" delegate:self cancelButtonTitle:string otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [viewcontrol presentViewController:alert animated:YES completion:nil];
    }
}

+ (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView
{
    //
    //    NSLog(@"行高  ＝ %f container = %@,xxx = %f",self.textview.font.lineHeight,self.textview.textContainer,self.textview.textContainer.lineFragmentPadding);
    //
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);//+self.textview.textContainer.lineFragmentPadding/*top*//*+theTextView.textContainer.lineFragmentPadding*//*there is no bottom padding*/);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);//ceilf(calculatedSize.height)
    return adjustedSize;
}
+(CGSize)stringSize:(NSString*)str font:(UIFont*)aFont width:(float)width
{
    NSString * string  =  str;
    CGSize size ;
    NSDictionary *attributes = @{NSFontAttributeName: aFont};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];
    size = rect.size;
    return size;
}
+ (CGSize) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit;
}
+ (NSString *)dictionaryTurnString:(NSMutableDictionary *)dictionary{
    NSString *postBody=@"";
    for (NSString *keys in dictionary.allKeys) {
        postBody = [NSString stringWithFormat:@"%@&%@=%@",postBody,keys,[dictionary objectForKey:keys]];
//        NSLog(@"postBody=%@",postBody);
    }
    return postBody;
}

+ (UIScrollView *)initializeScrollViewlWith:(CGRect )frame andView:(UIView *)superView andColor:(UIColor *)color
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:frame];
    scrollView.pagingEnabled =YES;
    scrollView.scrollEnabled =YES;
    scrollView.backgroundColor = color;
    
    [superView addSubview:scrollView];
    return scrollView;
}

+ (UIButton *)initBtnWithTitle:(NSString *)title
                               andTitleColor:(UIColor *)titleColor
                                andTitleFont:(float)titleFont
                                andSuperView:(UIView *)superView
                                    andFrame:(CGRect)frame{
    UIButton *button=[[UIButton alloc]initWithFrame:frame];
    [button setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    if([titleColor isKindOfClass:[UIColor class]]){
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    button.titleLabel.font = JY_Font_Sys(titleFont);
    [superView addSubview:button];
    return button;
}

+ (UIImageView *)initializeImageViewWithImagePath:(NSString *)pathResource
                                        andFrame:(CGRect )frame
                                    andSuperView:(UIView *)superView{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    [imageView setImage:[UIImage imageNamed:pathResource]];
    [superView addSubview:imageView];
    return imageView;
}

+ (UIControl *)initializeControlWithAndFrame:(CGRect )frame
                                andSuperView:(UIView *)superView{
    UIControl *control=[[UIControl alloc]initWithFrame:frame];
    [superView addSubview:control];
    return control;
}
+ (UILabel *)initializeLabelViewWithTitle:(NSString *)title
                                 andFrame:(CGRect )frame
                             andSuperView:(UIView *)superView
                                  andFont:(float )fontHeight
{
    CGSize size = [self stringSize:title font:JY_Font_Sys(fontHeight) width:JYScreenW];
    if (size.width > CGRectGetWidth(frame)) {
        frame.size.width = size.width;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = JY_Font_Sys(CGRectGetWidth(frame));
    label.textColor = kBlackColor;
    label.font = JY_Font_Sys(fontHeight);
    label.backgroundColor =kClearColor;
    label.text =title;
    if (superView != nil) {
        [superView addSubview:label];
    }
    return label;
}
+ (UILabel *)initializeLabelViewWithTitle:(NSString *)title
                                andFrame:(CGRect )frame
                            andSuperView:(UIView *)superView{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (CGRectGetWidth(frame)<16*JYScale_Width) {
       label.font = JY_Font_Sys(CGRectGetWidth(frame));
    }
    label.textColor = kBlackColor;
    label.backgroundColor =kClearColor;
    label.text =title;
    if (superView != nil) {
       [superView addSubview:label];
    }
    return label;
}

+ (UITextField *)initializeTextfieldViewWithPlaceholder:(NSString *)placeholder
                                        andFrame:(CGRect )frame
                                    andSuperView:(UIView *)superView{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
   
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder =placeholder;
    textField.textColor = kBlackColor;
    [superView addSubview:textField];
    return textField;
}
+ (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    return inset;
    
}
+ (CGRect)editingRectForBounds:(CGRect)bounds

{
    CGRect inset = CGRectMake(bounds.origin.x +10, bounds.origin.y, bounds.size.width -10, bounds.size.height);
    return inset;
}


+ (instancetype)checkView:(UIView *)myView andClass:(NSString*)viewClass
{
    Class myKindClass;
    id needReturnClass;
    if ([viewClass isEqualToString:@"button"]) {
        myKindClass=[UIButton class];
    }else if ([viewClass isEqualToString:@"textField"]) {
        myKindClass=[UITextField class];
    }else if ([viewClass isEqualToString:@"textView"]) {
        myKindClass=[UITextView class];
    }else if ([viewClass isEqualToString:@"imageView"]) {
        myKindClass=[UIImageView class];
    }else if ([viewClass isEqualToString:@"UILabel"]) {
        myKindClass=[UILabel class];
    }
    for (int x=0; x<myView.subviews.count; x++) {
        for (UIView *view in myView.subviews) {
            if ([view isKindOfClass:myKindClass]) {
                needReturnClass=view;
                break;
            }
        }
    }
    return needReturnClass;
}
+ (UIView *)creatBlankLine:(CGRect )frame andView:(UIView *)view andColor:(UIColor *)color
{
    UIView *mView=[[UIView alloc]initWithFrame:frame];
    mView.backgroundColor=color;
    if (view != nil) {
        mView.userInteractionEnabled = YES;
       [view addSubview:mView];
    }
    return mView;
}
//获取类的所有属性名
+ (NSArray*)getPropertieNamesByObject:(id)object {
    unsigned int outCount, i; // 获取注册类的属性列表，第一个参数是类，第二个参数是接收类属性数目的变量
    objc_property_t *properties = class_copyPropertyList([object class], &outCount); //定义一个数组来接收获取的属性名
    NSMutableArray *nameArray = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        //通过循环来获取单个属性
        objc_property_t property = properties[i];
        //取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //将得到的属性名放入数组中
        [nameArray addObject:propertyName];
    }
    free(properties);
    return nameArray;
}


+ (id)getSuperClass:(UIView *)childView andClass:(NSString *)classString{
    id superViewClass = childView;
    for (int x = 0; x < 5; x++) {
        if ([superViewClass isKindOfClass:[NSClassFromString(classString) class]]) {
            break;
        }else{
            superViewClass = [superViewClass superview];
        }
    }
    return superViewClass;
}

+ (BOOL)version:(NSString *)_oldver lessthan:(NSString *)_newver
{
    NSArray *a1 = [_oldver componentsSeparatedByString:@"."];
    NSArray *a2 = [_newver componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] floatValue] < [[a2 objectAtIndex:i] floatValue]) {
                return YES;
            }else if ([[a1 objectAtIndex:i] floatValue] > [[a2 objectAtIndex:i] floatValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}

+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

/*
 周边加阴影，并且同时圆角
 */
+ (void)addShadowToView:(UIView *)view
         andShadowColor:(UIColor *)shadowColor
            withOpacity:(float)shadowOpacity
           shadowRadius:(CGFloat)shadowRadius
        andCornerRadius:(CGFloat)cornerRadius
        andshadowOffset:(CGSize)shadowOffset
{
    //////// shadow /////////
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = view.layer.frame;
    
    shadowLayer.shadowColor = shadowColor.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = shadowOffset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;
    
    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);
    
    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    
    //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;
    
    //////// cornerRadius /////////
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    [view.superview.layer insertSublayer:shadowLayer below:view.layer];
}//拼接数组字符串
+ (NSString *)JoinStringWithArr:(NSMutableArray *)arr{
    NSString * string = @"";
    for (int x = 0; x < arr.count; x++) {
        string = [NSString stringWithFormat:@"%@%@",string,arr[x]];
    }
    return string;
}
+ (NSMutableAttributedString *)getAttributedStringWithContent:(NSString *)content withFont:(UIFont *)font{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0 , [content length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    return attributedString;
}
+ (NSMutableArray *)getSeparatedLinesFromString:(NSString *)text withFont:(UIFont *)font withWidth:(float)width withAttribute:(NSMutableAttributedString *)attStr
{
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}
@end
