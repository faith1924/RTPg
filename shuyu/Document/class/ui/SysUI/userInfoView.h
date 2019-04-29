//
//  userInfoView.h
//  RTPg
//
//  Created by tts on 2019/4/13.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "JYBasicView.h"

@class infoTBModel;
@class UIHeaderModel;

/**
 列表代理
 */
@protocol userInfoDelegate <NSObject>

- (void)infoTBView:(JYBasicTableView *)infoTBView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)clickHeadImage:(UIHeaderModel *)model;

@end

/**
 头部代理
 */
@protocol infoHeaderDelegate <NSObject>

- (void)clickHeadImage:(UIHeaderModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN


//===============================================头部===================================================================

@interface UIHeaderView : JYBasicView

@property (strong , nonatomic) UIImageView * headImg;

@property (strong , nonatomic) UILabel * userName;

@property (strong , nonatomic) UILabel * userID;

@property (weak , nonatomic) id <userInfoDelegate> TB_Delegate;

@property (weak , nonatomic) id <infoHeaderDelegate> HD_Delegate;

@property (strong , nonatomic) UIHeaderModel * model;

@end

@interface UIHeaderModel : JYBasicModel

@property (strong , nonatomic) NSString * headImg;

@property (strong , nonatomic) NSString * userName;

@property (strong , nonatomic) NSString * userID;

- (void)updataUI;
- (void)clearUI;

@end


//================================================列表================================================

@interface userInfoView : JYBasicView

@property (strong , nonatomic) UIView * contentView;

@property (strong , nonatomic) JYBasicTableView * infoTBView;

@property (strong , nonatomic) UIHeaderView * headerView;

@property (weak , nonatomic) id <userInfoDelegate> tbDelegate;

- (void)showContentView;

@end


@interface infoTBCell : JYBasicCell

@property (strong , nonatomic) infoTBModel * model;

@end

@interface infoTBModel :JYBasicModel

@property (strong , nonatomic) NSString <Optional> * title;//标题

@property (strong , nonatomic) NSString <Optional> * img;//图标

@property (strong , nonatomic) NSString <Optional> * cateId;

@property (strong , nonatomic) NSString <Optional> * desc;//描述

@property (strong , nonatomic) NSNumber <Optional> * arrow;//是否显示箭头

@end
NS_ASSUME_NONNULL_END
