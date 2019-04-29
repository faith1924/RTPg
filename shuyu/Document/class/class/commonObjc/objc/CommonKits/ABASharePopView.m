//
//  ABASharePopView.m
//  ABCMobileProject
//
//  Created by atts on 2018/7/16.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABASharePopView.h"
#import "LYAlertController.h"
#import "HSUpdateApp.h"

@interface ABASharePopView ()<GKPhotoBrowserDelegate>

@property (strong , nonatomic) UIButton * saveImageBtn;

@property (strong , nonatomic) NSMutableArray * imagesUrlArr;

@property (strong , nonatomic) NSMutableDictionary * photosDic;

@property (assign , nonatomic) NSInteger index;

@end

@implementation ABASharePopView
//单例
+ (ABASharePopView *)sharePopView{
    static  ABASharePopView * popView;
    static  dispatch_once_t queue;
    dispatch_once(&queue, ^{
        popView = [[ABASharePopView alloc]init];
    });
    return popView;
}
- (UIButton *)saveImageBtn{
    if (!_saveImageBtn) {
        _saveImageBtn = [JYCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:WDLGetKeyWindow andFrame:CGRectMake(JYScreenW - 95*JYScale_Width,JYScreenH - 75*JYScale_Width, 80*JYScale_Width, 60*JYScale_Height)];
        [_saveImageBtn addTarget:self action:@selector(saveImageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_saveImageBtn setImage:[UIImage imageNamed:@"SaveImage"] forState:UIControlStateNormal];
    }
    return _saveImageBtn;
}
- (void)saveImageBtnAction{
    UIImage * image = [_photosDic objectForKey:@(_index)];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{

}

//显示图片
- (void)shareImageWithImageDic:(NSMutableDictionary *)photos withImagesUrlArr:(NSMutableArray *)urlArr withIndex:(int)index{
    _photosDic = photos;
    _imagesUrlArr = urlArr;
    
    __block NSMutableArray *photosImages = [NSMutableArray new];
    [urlArr enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = obj;
        [photosImages addObject:photo];
    }];
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photosImages currentIndex:index];
    browser.delegate = [ABASharePopView sharePopView];
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    [browser showFromVC:[WDLUsefulKitModel getCurrentViewController]];
    [ABASharePopView sharePopView].saveImageBtn.hidden = NO;
}
// 结束滑动时 disappear：是否消失
- (void)photoBrowser:(GKPhotoBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear{
    _index = index;
}
// 单击事件
- (void)photoBrowser:(GKPhotoBrowser *)browser singleTapWithIndex:(NSInteger)index{
    [ABASharePopView sharePopView].saveImageBtn.hidden = YES;
}
//版本检测
+ (void)versionCheck:(void(^)(BOOL status))completeBlock{
    [HSUpdateApp hs_updateWithAPPID:@"" withBundleId:WDLTurnIdToString([[NSBundle mainBundle] bundleIdentifier]) block:^(NSString *currentVersion, NSString *storeVersion, NSString *openUrl, BOOL isUpdate) {
        if (isUpdate == YES) {
            LYAlertController * alertController = [LYAlertController alertControllerWithTitle:@"发现新版本" message:@"需要更新吗？" preferredStyle:UIAlertControllerStyleAlert];
            alertController.messageTextAlignment = NSTextAlignmentCenter;
            
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", openUrl]];
                [[UIApplication sharedApplication] openURL:cleanURL options:@{} completionHandler:^(BOOL success) {
                    exit(0);
                }];
            }];
            
            UIAlertAction * cancell = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:sureAction];
            [alertController addAction:cancell];
            [[WDLUsefulKitModel getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
//调用分享
+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
                      withShareDic:(NSMutableDictionary *)shareDic
{
    //创建网页内容对象
    UIImage  * thumbImage = [UIImage imageNamed:@"icon-40"];
    NSString * zlID = 0;
    NSString * dataID = 0;
    NSString * thumbURL =  @"";
    NSString * title = @"";
    NSString * desec =  @"";
    NSString * shareUrl =  @"";//弹出分享界面0文章详情。1 个人主页  2动态详情 3用户主页
    NSString * shareThumbnail =  WDLTurnIdToString(shareDic[@"shareThumbnail"]) ;//弹出分享界面0文章详情。1 个人主页  2动态详情 3用户主页
    if([shareDic[@"shareType"] isEqual:@(6)] || [shareDic[@"shareType"] isEqual:@(9)]){
        shareUrl =  WDLTurnIdToString(shareDic[@"zlicon"]);
        [ABASharePopView shareImageWithImageUrl:shareUrl andThumbImage:shareThumbnail andSharePlatformType:platformType andCompleteBlock:^(BOOL status) {
            if (status == YES) {
                NSString * typeid = WDLTurnIdToString(shareDic[@"shareType"]);
                if ([typeid isEqualToString:@"9"]) {
                    int channelID = 0;
                    switch (platformType) {
                        case 0:
                            channelID = 3;
                            break;
                        case 1:
                            channelID = 1;
                            break;
                        case 2:
                            channelID = 2;
                            break;
                        case 3:
                            channelID = 4;
                            break;
                        case 4:
                            channelID = 5;
                            break;
                            
                        default:
                            break;
                    }
                }
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享成功"];
            }else{
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享失败"];
            }
        }];
    }else if([shareDic[@"shareType"] isEqual:@(7)]){
        thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
        desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
        title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
        shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
        [ABASharePopView shareWebWithImageImage:thumbURL andShareUrl:shareUrl andShareTitle:title andShareDesc:desec andSharePlatformType:platformType andCompleteBlock:^(BOOL status) {
            if (status == YES) {
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享成功"];
            }else{
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享失败"];
            }
        }];
    }else if([shareDic[@"shareType"] isEqual:@(8)]){
        thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
        desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
        title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
        shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
        zlID = WDLTurnIdToString(shareDic[@"electionInfo"][@"zlid"]);
        dataID = WDLTurnIdToString(shareDic[@"electionInfo"][@"zlid"]);
        [ABASharePopView shareWebWithImageImage:thumbURL andShareUrl:shareUrl andShareTitle:title andShareDesc:desec andSharePlatformType:platformType andCompleteBlock:^(BOOL status) {
            if (status == YES) {
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享成功"];
            }else{
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享失败"];
            }
        }];
    }else{
        if([shareDic[@"shareType"] isEqual:@(1)]){//分享动态详情
            thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
            desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
            title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
            shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
            zlID = WDLTurnIdToString(shareDic[@"zlid"]);
            dataID = WDLTurnIdToString(shareDic[@"dataid"]);
        }else if([shareDic[@"shareType"] isEqual:@(2)]){//分享文章详情
            thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
            desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
            title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
            shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
            zlID = WDLTurnIdToString(shareDic[@"zlid"]);
            dataID = WDLTurnIdToString(shareDic[@"aid"]);
        }else if([shareDic[@"shareType"] isEqual:@(3)]){//分享用户主页
            thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
            desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
            title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
            shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
        }else if([shareDic[@"shareType"] isEqual:@(4)]){//分享众链
            thumbURL =  WDLTurnIdToString(shareDic[@"shareThumbnail"]);
            desec =  WDLTurnIdToString(shareDic[@"shareBrief"]);
            title =  WDLTurnIdToString(shareDic[@"shareTitle"]);
            shareUrl =  WDLTurnIdToString(shareDic[@"shareUrl"]);
            zlID = WDLTurnIdToString(shareDic[@"zlid"]);
            dataID = WDLTurnIdToString(shareDic[@"zlid"]);
        }
        NSLog(@"shareDic = %@",shareDic);
        [ABASharePopView shareWebWithImageImage:thumbURL andShareUrl:shareUrl andShareTitle:title andShareDesc:desec andSharePlatformType:platformType andCompleteBlock:^(BOOL status) {
            if (status == YES) {
                int channelID = 0;
                NSString * typeid = WDLTurnIdToString(shareDic[@"shareType"]);
                switch (platformType) {
                    case 0:
                        channelID = 3;
                        break;
                    case 1:
                        channelID = 1;
                        break;
                    case 2:
                        channelID = 2;
                        break;
                    case 3:
                        channelID = 4;
                        break;
                    case 4:
                        channelID = 5;
                        break;
                        
                    default:
                        break;
                }

//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享成功"];
            }else{
//                [[WDLAlertKit shareAlertView] showProgressHub:NSLoadingWithAutoHidden withContext:@"分享失败"];
            }
        }];
    }
}

//网页分享
+ (void)shareWebWithImageImage:(NSString * )thumbImage
                 andShareUrl:(NSString * )shareUrl
               andShareTitle:(NSString *)shareTitle
                andShareDesc:(NSString *)shareDesc
        andSharePlatformType:(UMSocialPlatformType)platformType
            andCompleteBlock:(void(^)(BOOL status))completeBlock{
    //创建分享消息对象
    UMSocialMessageObject * messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDesc thumImage:thumbImage];
    //设置网页地址
    shareObject.webpageUrl = shareUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[WDLUsefulKitModel getCurrentViewController] completion:^(id data, NSError *error) {
        if (error) {
            if (completeBlock) {
                completeBlock(NO);
            }
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
           NSLog(@"response data is %@",data);
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
}

//图片分享
+ (void)shareImageWithImageUrl:(NSString *)urlString
                 andThumbImage:(NSString * )thumbImage
          andSharePlatformType:(UMSocialPlatformType)platformType
              andCompleteBlock:(void(^)(BOOL status))completeBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = [UIImage imageNamed:@"icon-40"];
    shareObject.thumbImage = thumbImage;

    [shareObject setShareImage:urlString];
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:[WDLUsefulKitModel getCurrentViewController] completion:^(id data, NSError *error) {
        if (error) {
            if (completeBlock) {
                completeBlock(NO);
            }
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if (completeBlock) {
                completeBlock(YES);
            }
        }
    }];
}

+ (void)popSysTemBrowserWithUrlString:(NSString *)urlString{
    NSString * textURL =urlString;
    NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
    [[UIApplication sharedApplication] openURL:cleanURL options:@{} completionHandler:nil];
}

//根据url打开指定的页面
+ (void)popViewWithUrl:(NSURL *)urlString{

}

//打开详情
+ (void)popWebViewForShare:(NSString *)urlString{

}



@end
