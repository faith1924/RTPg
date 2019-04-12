//
//  ABAPopShareCategoryView.m
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/10/25.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import "ABAPopShareCategoryView.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

#define btnTag 15500
NSMutableDictionary * titleDic;
NSMutableArray * titleArr;
UIView * shareView;
@implementation ABAPopShareCategoryView
+ (ABAPopShareCategoryView *)shareView{
    static ABAPopShareCategoryView * shareView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView = [[ABAPopShareCategoryView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, JYScreenH)];
        [shareView addTarget:shareView action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        shareView.backgroundColor = RGBAOF(0x000000, 0.2);

        titleDic = [NSMutableDictionary new];
        PARAMS(titleDic, @"微信好友", @"more_wechat_icon");
        PARAMS(titleDic, @"朋友圈", @"more_friend_icon");
        PARAMS(titleDic, @"微博", @"more_weibo_icon");
        PARAMS(titleDic, @"QQ", @"more_qq_icon");
        PARAMS(titleDic, @"QQ空间", @"more_qqzone_icon");
        PARAMS(titleDic, @"复制链接", @"more_copy_icon");
    });
    return shareView;
}
- (void)initWithShareConfDic:(NSMutableDictionary *)shareDic
               withShareType:(int)shareType
                withShareArr:(NSMutableArray *)dataArr{
    self.shareDic = shareDic;
    self.shareType = shareType;
    self.dataArr = dataArr;
}

- (void)setShareType:(int)shareType{
    _shareType = shareType;
}
- (void)setShareDic:(NSMutableDictionary *)shareDic{
    _shareDic = shareDic;
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    self.hidden = NO;
    [WDLGetKeyWindow addSubview:self];
    
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    [_dataArr removeAllObjects];

    titleArr = [dataArr mutableCopy];
    
    NSMutableDictionary * dic = nil;
    for (int x = 0; x < dataArr.count; x++) {
        dic = [NSMutableDictionary new];
        NSString * key = WDLTurnIdToString(dataArr[x]);
        [dic setObject:WDLTurnIdToString(titleDic[key]) forKey:key];
        [_dataArr addObject:dic];
    }

    for(UIView * vi in self.subviews){
        if (vi != self.contentView) {
           [vi removeFromSuperview];
        }
    }
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    float ori = (JYScreenW - 60*JYScale_Width * 5 - 10*JYScale_Width * 6)/2;
    CGRect tFrame = CGRectMake(ori,25*JYScale_Width, 0, 0);
    
    UIButton * button;
    UILabel * platformLabel;
    NSString * imagePath = @"";
    for (int x = 0; x < dataArr.count; x++) {
        imagePath = [_dataArr[x] objectForKey:dataArr[x]];
        
        tFrame = CGRectMake(x%5 * 70*JYScale_Width + 15*JYScale_Width,x/5*91*JYScale_Width+ 25*JYScale_Width, 60*JYScale_Width,60*JYScale_Width);
        button = [JYCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:self.contentView andFrame:tFrame];
        [button setBackgroundImage:[UIImage imageNamed:imagePath] forState:UIControlStateNormal];
        button.tag = btnTag + x;
        [button setBackgroundColor:kWhiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        tFrame = CGRectMake(CGRectGetMinX(tFrame),CGRectGetMaxY(button.frame), 60*JYScale_Width, 30*JYScale_Width);
        platformLabel = [JYCommonKits initLabelViewWithLabelDetail:dataArr[x] andLabelColor:kGrayColor andLabelFont:11*JYScale_Height andLabelFrame:tFrame andJoinView:_contentView];
    }
    
    tFrame = CGRectMake(0,platformLabel.bottom + 15*JYScale_Height, JYScreenW, 50*JYScale_Height);
    UIButton * cancel = [JYCommonKits initButtonnWithButtonTitle:@"取消" andLabelColor:kGrayColor andLabelFont:16*JYScale_Height andSuperView:_contentView andFrame:tFrame];
    cancel.backgroundColor = kWhiteColor;
    [cancel addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    
    _contentView.frame = CGRectMake(0, JYScreenH, JYScreenW, CGRectGetMaxY(tFrame));
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.y = JYScreenH - self.contentView.height;
    }];
}
- (UIView * )contentView{
    if (_contentView == nil) {
        _contentView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, JYScreenH, JYScreenW, 1) andJoinView:self];
        _contentView.backgroundColor = [UIColor colorWithRed:207.0f/255.0f green:219.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    }
    return _contentView;
}
- (void)btnAction:(UIButton *)sender{
    long buttonTag = sender.tag - btnTag;
    NSString * title = titleArr[buttonTag];
    
    if (_shareDic == nil) {
        _shareDic = [NSMutableDictionary new];
    }

    if ([title isEqualToString:@"微信好友"]) {
        [self shareWithDic:_shareDic withPlat:UMSocialPlatformType_WechatSession];
    }else if ([title isEqualToString:@"朋友圈"]){
        [self shareWithDic:_shareDic withPlat:UMSocialPlatformType_WechatTimeLine];
    }else if ([title isEqualToString:@"微博"]){
        [self shareWithDic:_shareDic withPlat:UMSocialPlatformType_Sina];
    }else if ([title isEqualToString:@"QQ"]){
        [self shareWithDic:_shareDic withPlat:UMSocialPlatformType_QQ];
    }else if ([title isEqualToString:@"QQ空间"]){
        [self shareWithDic:_shareDic withPlat:UMSocialPlatformType_Qzone];
    }else if ([title isEqualToString:@"复制链接"]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = WDLTurnIdToString(_shareDic[@"shareUrl"]);
        [MBProgressHUD showMessage:@"复制成功"];
    }else{
        [self hiddenViewWithBlock:^{
            if (self.cateDelegate && [self.cateDelegate respondsToSelector:@selector(clickWithType:)]) {
                [self.cateDelegate clickWithType:title];
            }
        }];
    }
}
- (void)hiddenViewWithBlock:(void(^)(void))completeBlock{
    JYWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.y = JYScreenH;
    }completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        if (completeBlock) {
            completeBlock();
        }
    }];
}
- (void)hiddenView{
    JYWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.y = JYScreenH;
    }completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

//分享图文
- (void)shareWithDic:(NSMutableDictionary *)shareDic withPlat:(int )platType{
    if (![[UMSocialManager defaultManager] isInstall:platType]) {

        return;
    }
    //1.分享图片 2.分享图文
    if (_shareType == 1) {
        [self shareImageWithDic:shareDic withPlat:platType withCompleteBlock:^(BOOL status) {
            if (status == YES){
                [self hiddenViewWithBlock:^{
                    [MBProgressHUD showMessage:@"分享成功"];
                }];
            }
        }];
    }else if (_shareType == 2){
        [self shareContentImageWithDic:shareDic withPlat:platType withCompleteBlock:^(BOOL status) {
            if (status == YES){
                [self hiddenViewWithBlock:^{
                    [MBProgressHUD showMessage:@"分享成功"];
                }];
            }
        }];
    }
}


//分享图片
- (void)shareImageWithDic:(NSMutableDictionary *)shareDic
                 withPlat:(int )platType
        withCompleteBlock:(void(^)(BOOL status))complete{
    [self shareImageWithImageUrl:WDLTurnIdToString(shareDic[@"shareUrl"]) andThumbImage:WDLTurnIdToString(shareDic[@"shareThumbnail"]) andSharePlatformType:platType andCompleteBlock:^(BOOL status) {
        if (status == YES) {
            complete(status);
        }
    }];
}
//分享图文
- (void)shareContentImageWithDic:(NSMutableDictionary *)shareDic
                        withPlat:(int )platType
               withCompleteBlock:(void(^)(BOOL status))complete{
    [self shareWebWithImageImage:WDLTurnIdToString(shareDic[@"shareThumbnail"])
                     andShareUrl:WDLTurnIdToString(shareDic[@"shareUrl"])
                   andShareTitle:WDLTurnIdToString(shareDic[@"shareTitle"])
                    andShareDesc:WDLTurnIdToString(shareDic[@"shareBrief"])
            andSharePlatformType:platType
                andCompleteBlock:^(BOOL status) {
                    complete(status);
    }];
}

//图文分享
- (void)shareWebWithImageImage:(NSString *)thumbImage
                   andShareUrl:(NSString *)shareUrl
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
- (void)shareImageWithImageUrl:(NSString *)urlString
                 andThumbImage:(NSString * )thumbImage
          andSharePlatformType:(UMSocialPlatformType)platformType
              andCompleteBlock:(void(^)(BOOL status))completeBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    
    //如果有缩略图，则设置缩略图
    if ([thumbImage isEqualToString:@"icon-60"]) {
        shareObject.thumbImage = thumbImage;
    }else{
        shareObject.thumbImage = thumbImage;
    }

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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
