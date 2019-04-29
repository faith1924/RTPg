//
//  ABASharePopView.h
//  ABCMobileProject
//
//  Created by atts on 2018/7/16.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>
#import "GKPhotoBrowser.h"

@interface ABASharePopView : NSObject
//单例
+ (ABASharePopView *)sharePopView;
//打开图片
- (void)shareImageWithImageDic:(NSMutableDictionary *)photos withImagesUrlArr:(NSMutableArray *)urlArr withIndex:(int)index;
//版本检测
+ (void)versionCheck:(void(^)(BOOL status))completeBlock;
//根据url打开指定的页面
+ (void)popViewWithUrl:(NSURL *)urlString;


//外置浏览器打开网页
+ (void)popSysTemBrowserWithUrlString:(NSString *)urlString;

//打开分享页面
+ (void)popWebViewForShare:(NSString *)urlString;

//调用分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                      withShareDic:(NSMutableDictionary *)shareDic;

//网页分享
+ (void)shareWebWithImageImage:(NSString  *)thumbImage
                 andShareUrl:(NSString * )shareUrl
               andShareTitle:(NSString *)shareTitle
                andShareDesc:(NSString *)shareDesc
        andSharePlatformType:(UMSocialPlatformType)platformType
            andCompleteBlock:(void(^)(BOOL status))completeBlock;

//图片分享
+ (void)shareImageWithImageUrl:(NSString *)urlString
                 andThumbImage:(NSString * )thumbImage
          andSharePlatformType:(UMSocialPlatformType)platformType
              andCompleteBlock:(void(^)(BOOL status))completeBlock;

@end
