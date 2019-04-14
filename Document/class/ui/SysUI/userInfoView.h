//
//  userInfoView.h
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/13.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYBasicView.h"


/**
 列表代理
 */
@protocol infoTBDelegate <NSObject>

@end

/**
 头部代理
 */
@protocol infoDelegate <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@class infoTBModel;
@class UIHeaderModel;

//===============================================头部===================================================================

@interface UIHeaderView : JYBasicView

@property (strong , nonatomic) UIImageView * headImg;

@property (strong , nonatomic) UILabel * userName;

@property (weak , nonatomic) id <infoDelegate> delegate;

@property (strong , nonatomic) UIHeaderModel * model;

@end

@interface UIHeaderModel : JYBasicModel

@property (strong , nonatomic) NSString * headImg;

@property (strong , nonatomic) NSString * userName;

@end


//================================================列表================================================

@interface userInfoView : JYBasicView

@property (strong , nonatomic) JYBasicTableView * infoTBView;

@property (strong , nonatomic) UIHeaderView * headerView;

@property (weak , nonatomic) id <infoTBDelegate> tbDelegate;

@end


@interface infoTBCell : JYBasicCell

@property (strong , nonatomic) infoTBModel * model;

@end

@interface infoTBModel :JYBasicModel

@property (strong , nonatomic) NSString <Optional> * title;//标题

@property (strong , nonatomic) NSString <Optional> * img;//图标

@property (strong , nonatomic) NSString <Optional> * cateId;

@property (strong , nonatomic) NSString <Optional> * desc;//描述

@end
NS_ASSUME_NONNULL_END
