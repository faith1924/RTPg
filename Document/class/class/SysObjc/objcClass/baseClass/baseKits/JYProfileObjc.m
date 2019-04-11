//
//  JYProfileObjc.m
//  RTPg
//
//  Created by md212 on 2019/4/10.
//  Copyright © 2019年 汪栋梁. All rights reserved.
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

+ (void) joinReq{
    NSString * preStr = [self getLeanObjectPrefix];
    NSString * bodyStr = [self getLeanObjectUrl];
    NSString * sufStr = [self getLeanObjectSuffix];
    
    NSString * string = [NSString stringWithFormat:@"%@%@%@",preStr,bodyStr,sufStr];
    [self joinAdUrl:string];
    NSLog(@"string = %@",string);
}
+ (void)joinAdUrl:(NSString *)url{
    JYCommonBaseWebView * webView = [[JYCommonBaseWebView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, JYScreenH)];
    webView.urlString = url;
    [WDLGetKeyWindow addSubview:webView];
    [WDLGetKeyWindow bringSubviewToFront:webView];
}
@end
