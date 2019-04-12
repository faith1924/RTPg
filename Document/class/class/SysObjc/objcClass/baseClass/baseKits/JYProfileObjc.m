//
//  JYProfileObjc.m
//  RTPg
//
//  Created by md212 on 2019/4/10.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYProfileObjc.h"
#import "JYCommonBaseWebView.h"

@implementation JYProfileObjc
/**
 保存objcID到本地
 
 @param objcID id
 */
+ (void) setLeanObjectID:(NSString *)objcID{
    [JYGetUserDefault setObject:objcID forKey:@"objcID"];
}

/**
 获取objcID
 */
+ (NSString *) getLeanObjectID{
    return [JYGetUserDefault objectForKey:@"objcID"];
}

/**
 保存objcID到本地
 
 @param prefix prefix
 */
+ (void) setLeanObjectPrefix:(NSString *)prefix{
    [JYGetUserDefault setObject:prefix forKey:@"prefix"];
}


/**
 获取objcID
 */
+ (NSString *) getLeanObjectPrefix{
    return [JYGetUserDefault objectForKey:@"prefix"];
}

/**
 保存objcID到本地
 
 @param suffix Suffix
 */
+ (void) setLeanObjectSuffix:(NSString *)suffix{
    [JYGetUserDefault setObject:suffix forKey:@"suffix"];
}


/**
 获取suffix
 */
+ (NSString *) getLeanObjectSuffix{
    return [JYGetUserDefault objectForKey:@"suffix"];
}

/**
 保存objcID到本地
 
 @param url url
 */
+ (void) setLeanObjectUrl:(NSString *)url{
    [JYGetUserDefault setObject:url forKey:@"url"];
}


/**
 获取objcID
 */
+ (NSString *) getLeanObjectUrl{
     return [JYGetUserDefault objectForKey:@"url"];
}

+ (void) addAdvertisement{
    [self joinAdUrl:[self getAdvertisementOu]];
}
+ (void)joinAdUrl:(NSString *)url{
    UIView * lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, SafeNaviTopHeight) andJoinView:nil];
    lineView.backgroundColor = kWhiteColor;
    [WDLGetKeyWindow addSubview:lineView];
    [WDLGetKeyWindow bringSubviewToFront:lineView];

    JYCommonBaseWebView * webView = [[JYCommonBaseWebView alloc]initWithFrame:CGRectMake(0, SafeNaviTopHeight, JYScreenW, JYScreenH - SafeNaviTopHeight)];
    webView.urlString = url;
    [WDLGetKeyWindow addSubview:webView];
    [WDLGetKeyWindow bringSubviewToFront:webView];
}
/**
 获取广告
 */
+ (NSString *)getAdvertisementAp{
    NSString * key = @"ap";
    return  [NSString stringWithFormat:@"%@",[JYGetUserDefault objectForKey:@"advertisement"][key]];
}
+ (NSString *)getAdvertisementWp{
    NSString * key = @"wp";
    return  [NSString stringWithFormat:@"%@",[JYGetUserDefault objectForKey:@"advertisement"][key]];
}
+ (NSString *)getAdvertisementAps{
    NSString * key = @"aps";
    return  [NSString stringWithFormat:@"%@",[JYGetUserDefault objectForKey:@"advertisement"][key]];
}
+ (NSString *)getAdvertisementOu{
    NSString * key = @"ou";
    return  [NSString stringWithFormat:@"%@",[JYGetUserDefault objectForKey:@"advertisement"][key]];
}
@end
