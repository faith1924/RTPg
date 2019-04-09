//
//  ABAPopShareCategoryView.h
//  ABCMobileProject
//
//  Created by 蚂蚁区块链联盟 on 2018/10/25.
//  Copyright © 2018年 蚂蚁区块链联盟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ABAPopShareCategoryViewDelegate <NSObject>
- (void)clickWithType:(NSString *)title;
@end

@interface ABAPopShareCategoryView : UIControl
@property (strong , nonatomic) NSMutableArray * dataArr;
@property (strong , nonatomic) NSMutableDictionary * shareDic;
@property (strong , nonatomic) NSString * userid;
@property (strong , nonatomic) UIView * contentView;
@property (strong , nonatomic) void(^compHid)(void);
@property (weak , nonatomic) id<ABAPopShareCategoryViewDelegate>cateDelegate;

@property (assign , nonatomic) BOOL needRequest;//是否需要回调到服务器
@property (assign , nonatomic) int shareType;//1.分享图片 2.分享图文
@property (assign , nonatomic) int shareSource;//0网页 1动态 2文章 3平台用户 4众链主页 5平台用户主页 6快讯

+ (ABAPopShareCategoryView *)shareView;
- (void)initWithShareConfDic:(NSMutableDictionary *)shareDic
                  withUserid:(NSString *)userID
             withNeedRequest:(BOOL)needRequest
             withShareSource:(int)shareSource
               withShareType:(int)shareType
                withShareArr:(NSMutableArray *)dataArr;
@end

NS_ASSUME_NONNULL_END
