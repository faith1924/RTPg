//
//  JYBasicViewController.m
//  ABCMobileProject
//
//  Created by mmy on 2018/12/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "JYBasicViewController.h"
#import <UMAnalytics/MobClick.h>

@interface JYBasicViewController ()<JYBasicViewControllerDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong ,nonatomic) NSString * loadStatus;//页面加载状态

@property (strong , nonatomic) UIButton * button;

@end
@implementation JYBasicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置基类初始属性
    [self viewConfiInfo];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.viewNavigationBar.title];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick endLogPageView:self.viewNavigationBar.title];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewConfiInfo{
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = kWhiteColor;
    self.isArrowPrintLog = NO;
    self.OpenTheLeftBackOfAll = YES;
    self.reqType = 0;
    
    self.contentView = [[JYUIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.contentView.delegate = self;
    self.contentView.bounces = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    
    _viewNavigationBar = [[JYUINavigationBar alloc]initWithFrame:CGRectZero];
    _viewNavigationBar.titleLabel.alpha = 1;
    _viewNavigationBar.title = self.title;
    [_viewNavigationBar setBtnWithImageArr:@[@"back_btn_blue@"] withDelegate:self withActionArr:@[@"popBackView"] isLeft:YES];
    
    [self setIsShowBar:YES];
    [self.view addSubview:_viewNavigationBar];
    [self.view addSubview:self.contentView];
}
- (JYRequesModel *)reqModel{
    if (_reqModel == nil) {
        _reqModel = [[JYRequesModel alloc]init];
    }
    return _reqModel;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 设置基类加载属性
    [self setTheLoadProperties];
}
- (void)setTheLoadProperties{
    // 将默认关闭全继承左滑返回手势
    if (_OpenTheLeftBackOfAll) {
        if (_isArrowPrintLog) {
            NSLog(@"\n开启了全继承左滑返回手势\n");
        }
    }
}
/**
 *  返回手势代理
 *
 *  @param gestureRecognizer gestureRecognizer
 *
 *  @return BOOL
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.childViewControllers.count > 1;
}
/**
 *  返回方法
 *
 */
- (void)handleNavigationTransition:(UISwipeGestureRecognizer *)sender {
    [self popBackView];
}
- (void)popBackView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSubview:(UIView *)view{
    if (view) {
        [self.contentView addSubview:view];
        if (view.bottom > self.contentView.height) {
            self.contentView.scrollEnabled = YES;
            self.contentView.contentSize = CGSizeMake(self.view.width,view.bottom);
        }else{
            self.contentView.scrollEnabled = NO;
        }
    }
    if (self.getViewHeight) {
        self.getViewHeight(self.contentView.height);
    }
}

/**
 *  点方法
 *
 */
- (void)setIsShowBar:(BOOL)isShowBar{
    _isShowBar = isShowBar;
    _viewNavigationBar.height = (_isShowBar == NO?0:SafeAreaTopHeight);
    if (_isShowBar == YES) {
        self.viewNavigationBar.top = 0;
        self.viewNavigationBar.left = 0;
        self.contentView.top = _viewNavigationBar.bottom;
        self.contentView.height = self.view.height - _viewNavigationBar.bottom;
    }else{
        self.contentView.top = 0;
        self.contentView.left = 0;
        self.contentView.height = self.view.height;
    }
    _viewNavigationBar.hidden = !_isShowBar;
}

- (void)setViewNavigationBar:(JYUINavigationBar *)viewNavigationBar{
    _viewNavigationBar = viewNavigationBar;
    self.isShowBar = YES;
    [self.view addSubview:_viewNavigationBar];
}
- (void)setIsArrowPrintLog:(BOOL)isArrowPrintLog{
    _isArrowPrintLog = isArrowPrintLog;
}
- (void)setIsShowEmpty:(BOOL)isShowEmpty{
    _isShowEmpty = isShowEmpty;
}
- (void)setLoadDelegate:(id<JYBasicViewControllerDelegate>)loadDelegate{
    if (loadDelegate) {
        _loadDelegate = loadDelegate;
        
        self.reqModel = [self.loadDelegate getReqModel];

        [self loadData:^(id data, BOOL status) {
            if (status) {
                JYLog(@"数据加载完成");
            }
        }];
    }
}

#pragma mark JYBasicViewControllerDelegate
- (void)loadData:(void(^)(id data,BOOL status))complete{
    __block JYWeakify(self);
    _loadStatus = @"开始请求";
    
    if (_reqType == NO) {
        [[JYAFNetManager manager] POSTWithURL:_reqModel.link Parameters:_reqModel.parameters Success:^(NSDictionary *success) {
            [weakSelf loadDataSuccess:success];
            if (complete) {
                complete(success,YES);
            }
        } Failure:^(NSError *error) {
            [weakSelf loadDataFail:error withParams:weakSelf.reqModel.parameters withUrl:weakSelf.reqModel.link];
        }];
    }else{
        [[JYAFNetManager manager] GetWithURL:_reqModel.link Parameters:_reqModel.parameters Success:^(id success) {
            [weakSelf loadDataSuccess:success];
            if (complete) {
                complete(success,YES);
            }
        } Failure:^(NSError *error) {
             [weakSelf loadDataFail:error withParams:weakSelf.reqModel.parameters withUrl:weakSelf.reqModel.link];
        }];
    }
}
- (void)loadDataSuccess:(id)data{
    _loadStatus = @"请求成功";
    [self setupUIWithData:data];
}
- (void)loadDataFail:(id)data withParams:(id)params withUrl:(NSString *)urlString{
    _loadStatus = @"请求失败";
    if (_isShowEmpty) {
        [self addSubview:self.emptyView];
    }else{
        [self.emptyView removeFromSuperview];
    }
    
    JYLog(@"请求失败：data = %@\nparams = %@\nurlString = %@",data,params,urlString);
}

/**
 *  通知中心
 */
- (void)addObserve:(NSArray *)arr withObj:(id)obj{

}
/**
 *  刷新数据
 */
- (void)reloadData{
    //移除页面
    NSLog(@"重新刷新");
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [self loadData:nil];
}
/**
 *  加载页面
 */
- (void)setupUIWithData:(id)data{
    _loadStatus = @"页面加载完毕";
    NSLog(@"data = %@",data);
}

/**
 *  日志打印
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"ViewControllerLoadStatus"]) {
        if (_isArrowPrintLog) {
            NSLog(@"%@",_loadStatus);
        }
    }
}

/**
 *  内存释放
 */
- (void)dealloc{
    if (_isArrowPrintLog) {
        NSLog(@"界面已销毁%@\n %@",self.viewNavigationBar.title,[self class]);
    }
    self.loadDelegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
