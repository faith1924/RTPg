//
//  ABAPopShareCategoryView.h
//  ABCMobileProject
//
//  Created by mylm on 2018/10/25.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ABAPopShareCategoryViewDelegate <NSObject>
- (void)clickWithType:(NSString *)title;
@end

@interface ABAPopShareCategoryView : UIControl
@property (strong , nonatomic) NSMutableArray * dataArr;
@property (strong , nonatomic) NSMutableDictionary * shareDic;
@property (strong , nonatomic) UIView * contentView;
@property (strong , nonatomic) void(^compHid)(void);
@property (weak , nonatomic) id<ABAPopShareCategoryViewDelegate>cateDelegate;
@property (assign , nonatomic) int shareType;//1.分享图片 2.分享图文

+ (ABAPopShareCategoryView *)shareView;
- (void)initWithShareConfDic:(NSMutableDictionary *)shareDic
               withShareType:(int)shareType
                withShareArr:(NSMutableArray *)dataArr;
@end

NS_ASSUME_NONNULL_END
