//
//  JYBasicTableView.h
//  ABCMobileProject
//
//  Created by mmy on 2018/12/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYBasicModel.h"
#import "JYBasicCell.h"
#import "JYEmptyView.h"
#import "JYRequesModel.h"

typedef NS_ENUM(NSInteger , RequestStatus){
    Req_Success = 0,
    Req_Failure = 1,
};

NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_END
@class JYBasicTableView;

@protocol JYBasicTableViewReqDelegate <NSObject>
@optional
/**
 *  获取加载参数
 */
- (JYRequesModel *)getReqModel;//获取请求参数
- (BOOL)getReqType;//获取请求类型
/**
 *  有可能需要重写
 */
- (void)loadDataSuccess:(id)data withParams:(NSMutableDictionary *)params withUrlString:(NSString *)urlString;
@end

@protocol JYTableViewDataSource <NSObject>
@required
/**
 *  数据源头
 */
-(JYBasicCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  获取model类型
 */
- (JYBasicModel *)getModelWithObj:(id)obj;
@optional
/**
 *  数据源头
 */
-(UIView *)listContentHeaderView:(JYBasicTableView *)tableView;
-(CGFloat)listContentHeaderHeightView:(JYBasicTableView *)tableView;

-(UIView *)listContentFooterView:(JYBasicTableView *)tableView;
-(CGFloat)listContentFooterHeightView:(JYBasicTableView *)tableView;

-(UIView *)heightForSectionHeader:(JYBasicTableView *)tableView;
-(CGFloat)heightForSectionHeaderHeight:(JYBasicTableView *)tableView;

-(UIView *)heightForSectionFooter:(JYBasicTableView *)tableView;
-(CGFloat)heightForSectionFooterHeight:(JYBasicTableView *)tableView;

//滑动删除
- (BOOL)listContentView:(JYBasicTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCellEditingStyle)listContentView:(JYBasicTableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray<UITableViewRowAction *> *)listContentView:(JYBasicTableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface JYBasicTableView : UITableView
@property (weak , nonatomic ) id <JYBasicTableViewReqDelegate>listDelegate;

@property (weak , nonatomic ) id <JYTableViewDataSource>dataDelegate;

@property (assign , nonatomic) NSIndexPath * currentIndex;

@property (strong , nonatomic) NSString * emptyTitle;

@property (nonatomic , assign) int page;

@property (assign , nonatomic) int totalPage;

@property (assign , nonatomic) int EPCount; //每次返回的条数

@property (strong ,nonatomic) NSString * loadStatus;//页面加载状态

@property (strong , nonatomic) JYRequesModel * reqModel;

@property (assign , nonatomic) RequestStatus reqStatus;

/**
 *  头部刷新自定义
 */
@property (strong , nonatomic) UIColor * refreshBgColor;//设置刷新背景颜色
@property (strong , nonatomic) UIColor * refreshTextColor;//设置文字颜色
@property (assign , nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 *  数据
 */
@property (strong , nonatomic) NSMutableArray * listArray;

/**
 *  model
 */
@property (strong , nonatomic) NSMutableArray <JYBasicModel *>* listModel;

/**
 *  打开日志打印
 */
@property(nonatomic,assign)BOOL isArrowPrintLog;

/**
 *  导入刷新
 */
@property(nonatomic,strong) NSArray <NSString *>* notificationArr;

/**
 *  如果加载到的数据为空
 */
@property(nonatomic,strong) JYEmptyView * emptyView;

/**
 *  是否显示空页面
 */
@property(nonatomic,assign) BOOL isShowEmpty;

/**
 *  返回高度
 */
@property(nonatomic,assign) void(^getViewHeight)(CGFloat height);


/**
 *  页面初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                 withDelegate:(id)delegate;

/**
 *  通知中心
 */
- (void)addObserve:(NSArray *)arr withObj:(id)obj;

/**
 *  获取model数组
 */
- (NSMutableArray *)getModelWithArr:(NSArray *)arr;
- (void)initArrWithDic:(id )dic
            withParams:(NSMutableDictionary *)params
         withUrlString:(NSString *)urlString;

- (void)appendArrWithDic:(id )dic
              withParams:(NSMutableDictionary *)params
           withUrlString:(NSString *)urlString;

- (void)dropDownRefresh;
- (void)endRefresh:(RequestStatus)status;
- (void)loadData;
/**
 设置固定初始数据

 @param dataArr 数据
 */
- (void)setDataArr:(NSMutableArray * )dataArr;
@end


