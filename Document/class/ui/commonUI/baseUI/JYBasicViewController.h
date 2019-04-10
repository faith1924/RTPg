//
//  JYBasicViewController.h
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBasicView.h"
#import "JYUINavigationBar.h"
#import "JYRequesModel.h"
#import "JYEmptyView.h"

@protocol JYBasicViewControllerDelegate <NSObject>

/**
 *  数据开始加载
 */
- (void)reloadData;

/**
 *  获取加载参数
 */
- (JYRequesModel *)getReqModel;

@end

@interface JYBasicViewController : UIViewController

@property (weak , nonatomic) id<JYBasicViewControllerDelegate>loadDelegate;

/**
 *  导航栏
 */
@property (strong , nonatomic) JYUINavigationBar * viewNavigationBar;
@property (strong , nonatomic) JYUIScrollView * contentView;

/**
 *  是否显示导航栏
 */
@property(nonatomic,assign)BOOL isShowBar;

/**
 *  打开日志打印
 */
@property(nonatomic,assign)BOOL isArrowPrintLog;

/**
 请求类型
 */
@property(nonatomic , assign )BOOL reqType; //0 get 1 post

/**
 *  是否开启全继承左滑返回手势 默认NO
 */
@property(nonatomic,assign)BOOL OpenTheLeftBackOfAll;

/**
 *  返回高度
 */
@property(nonatomic,assign) void(^getViewHeight)(CGFloat height);

/**
 *  请求参数
 */

@property (strong ,nonatomic) JYRequesModel * reqModel;


/**
 *  如果加载到的数据为空
 */
@property(nonatomic,strong) UIView * emptyView;

/**
 *  是否显示空页面
 */
@property(nonatomic,assign) BOOL isShowEmpty;


/**
 *  页面加载
 */
- (void)setupUIWithData:(id)data;

/**
 *  通知中心
 */
- (void)addObserve:(NSArray *)arr withObj:(id)obj;

/**
 *  数据开始加载
 */
- (void)loadData:(void(^)(id data,BOOL status))complete;

/**
 *  提交请求
 */
- (void)submitDataWithParams:(NSMutableDictionary *)params
                     withUrl:(NSString *)urlString
                   withBlock:(void(^)(id data,BOOL status))complete;
/**
 *  添加页面;
 */
- (void)addSubview:(UIView *)view;

@end

