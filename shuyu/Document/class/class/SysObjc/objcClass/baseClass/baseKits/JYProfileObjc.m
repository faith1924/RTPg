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
static JYCommonBaseWebView * webView;
static UIView * lineView ;

+ (instancetype) shareProfileModel{
    static JYProfileObjc * onceModelToken;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceModelToken = [[super allocWithZone:NULL] init];
    });
    return onceModelToken;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [JYProfileObjc shareProfileModel];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [JYProfileObjc shareProfileModel];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [JYProfileObjc shareProfileModel];
}

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

+ (void) newsConf{
    [self joinAdUrl:[self getOu]];
}
+ (void)joinAdUrl:(NSString *)url{
    if (![url isEqualToString:@""]) {
        lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, SafeNaviTopHeight) andJoinView:nil];
        lineView.backgroundColor = kWhiteColor;
        [WDLGetKeyWindow addSubview:lineView];
        [WDLGetKeyWindow bringSubviewToFront:lineView];
        
        webView = [[JYCommonBaseWebView alloc]initWithFrame:CGRectMake(0, SafeNaviTopHeight, JYScreenW, JYScreenH - SafeNaviTopHeight)];
        webView.urlString = url;
        [WDLGetKeyWindow addSubview:webView];
        [WDLGetKeyWindow bringSubviewToFront:webView];
    }
}
+ (void)confUser:(float)conf{
    webView.alpha = conf;
    lineView.alpha = conf;
}
/**
 获取广告
 */
+ (NSString *)getAp{
    return [self getString:@"ap"];
}
+ (NSString *)getWp{
    return [self getString:@"wp"];
}
+ (NSString *)getAps{
    return [self getString:@"aps"];
}
+ (NSString *)getOu{
    return [self getString:@"userID"];
}

+ (NSString *)getString:(NSString *)key{
    if([[LeanCloudResModel shareCloudModel].clientUserInfo[key] isKindOfClass:[NSString class]]){
        return  WDLTurnIdToString([LeanCloudResModel shareCloudModel].clientUserInfo[key]);
    }else{
        NSString * jsonString = WDLTurnIdToString([LeanCloudResModel shareCloudModel].clientUserInfo[key]);
        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = nil;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            return WDLTurnIdToString(dic[key]);
        }else{
            NSDictionary * mDic = (NSDictionary *)jsonString;
            return WDLTurnIdToString(mDic[key]);
        }
    }
}
@end
