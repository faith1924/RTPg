//
//  JYBasicTableView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/12/24.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "JYBasicTableView.h"
#import "JYBasicModel.h"

@interface JYBasicTableView ()<JYTableViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>


@property (weak , nonatomic) id<JYTableViewDelegate>loadDelegate;

@property (strong , nonatomic) UIView * headerView;
@property (strong , nonatomic) UIView * footerView;

@property (strong , nonatomic) UIView * tbHeaderView;
@property (strong , nonatomic) UIView * tbFooterView;

@property (strong , nonatomic) MJRefreshNormalHeader * refreshHeaderView;
@property (strong , nonatomic) MJRefreshAutoNormalFooter * refreshFooterView;

@end
@implementation JYBasicTableView
- (instancetype)initWithFrame:(CGRect)frame
                 withDelegate:(id)delegate{
    if(self = [super initWithFrame:frame style:UITableViewStylePlain]){
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        if (delegate) {
            _loadDelegate = delegate;
            _listDelegate = delegate;
            _dataDelegate = delegate;
            
            if ([_dataDelegate respondsToSelector:@selector(listContentHeaderView:)]) {
                self.tableHeaderView = [self.dataDelegate listContentHeaderView:self];
            }
            if ([_dataDelegate respondsToSelector:@selector(listContentFooterView:)]) {
                self.tableFooterView = [self.dataDelegate listContentFooterView:self];
            }

            [self loadData];
        }else{
            _loadDelegate = self;
            _listDelegate = delegate;
            _dataDelegate = delegate;
        }
        _totalPage = 100;
        _EPCount = defaultNumberData;
        
        self.delegate = self;
        self.dataSource = self;

//        _refreshHeaderView = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
//        self.mj_header =_refreshHeaderView;
        
//        _refreshFooterView = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dropUpLoadMore)];
//        self.mj_footer = _refreshFooterView;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        _isDropDownRefresh = YES;
        _isDropUpRefresh = YES;
        
        _page = 1;
        _isShowEmpty = YES;
        _emptyTitle = @"未加载到任何数据";
    }
    return self;
}
-(void)setIsDropUpRefresh:(BOOL)isDropUpRefresh{
    _isDropUpRefresh = isDropUpRefresh;
}
-(void)setIsDropDownRefresh:(BOOL)isDropDownRefresh{
    _isDropDownRefresh = isDropDownRefresh;
}
- (void)setRefreshBgColor:(UIColor *)refreshBgColor{
    if (refreshBgColor == nil) {
        return;
    }
    [_refreshHeaderView setBackgroundColor:refreshBgColor];
}
- (void)setRefreshTextColor:(UIColor *)refreshTextColor{
    if (refreshTextColor == nil) {
        return;
    }
    _refreshHeaderView.stateLabel.textColor = refreshTextColor;
    _refreshHeaderView.lastUpdatedTimeLabel.textColor = refreshTextColor;
}
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    _refreshHeaderView.activityIndicatorViewStyle = activityIndicatorViewStyle;
}
- (void)setIsArrowPrintLog:(BOOL)isArrowPrintLog{
    _isArrowPrintLog = isArrowPrintLog;
}
- (void)setIsShowEmpty:(BOOL)isShowEmpty{
    _isShowEmpty = isShowEmpty;
}

/**
 *  通知中心
 */
- (void)addObserve:(NSArray *)arr withObj:(id)obj{
    if (arr != nil && arr.count > 0) {
        _notificationArr = arr;
        for (int x = 0; x < arr.count; x++) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:_notificationArr[x] object:nil];
        }
    }
}
/**
 *  加载页面
 */
- (void)setupUI{
    _loadStatus = @"页面加载完毕";
}

/**
 *  日志打印
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"tableViewLoadStatus"]) {
        if (_isArrowPrintLog) {
            NSLog(@"%@",_loadStatus);
        }
    }
}
#pragma mark JYBasicViewControllerDelegate
- (void)loadData{
    if (![self.listDelegate respondsToSelector:@selector(getReqModel)]) {
        [self endRefresh:NO];
        return;
    }
    _reqModel = [self.listDelegate getReqModel];

    JYWeakify(self);
    _loadStatus = @"开始请求";
    if(self.reqModel.reqType == 0){
        [[JYAFNetManager manager] POSTWithURL:_reqModel.link Parameters:_reqModel.parameters Success:^(NSDictionary *responseJson) {
            weakSelf.reqStatus = Req_Success;
            if ([weakSelf.listDelegate respondsToSelector:@selector(loadDataSuccess:withParams:withUrlString:)] && weakSelf.listDelegate) {
                [weakSelf.listDelegate loadDataSuccess:responseJson withParams:weakSelf.reqModel.parameters  withUrlString:weakSelf.reqModel.link];
            }else{
                [weakSelf loadDataSuccess:responseJson withParams:weakSelf.reqModel.parameters withUrlString:weakSelf.reqModel.link];
            }
        } Failure:^(NSError *error) {
            weakSelf.reqStatus = Req_Failure;
            [weakSelf loadDataFail:error withParams:weakSelf.reqModel.parameters withUrl:weakSelf.reqModel.link];
        }];
    }else{
        [[JYAFNetManager manager] GetWithURL:_reqModel.link Parameters:_reqModel.parameters Success:^(id responseJson) {
            if ([weakSelf.listDelegate respondsToSelector:@selector(loadDataSuccess:withParams:withUrlString:)] && weakSelf.listDelegate) {
                [weakSelf.listDelegate loadDataSuccess:responseJson withParams:weakSelf.reqModel.parameters  withUrlString:weakSelf.reqModel.link];
            }else{
                [weakSelf loadDataSuccess:responseJson withParams:weakSelf.reqModel.parameters withUrlString:weakSelf.reqModel.link];
            }
        } Failure:^(NSError *error) {
            [weakSelf loadDataFail:error withParams:weakSelf.reqModel.parameters withUrl:weakSelf.reqModel.link];
        }];
    }
}
- (void)loadDataSuccess:(id)data withParams:(NSMutableDictionary *)params withUrlString:(NSString *)urlString{
    _loadStatus = @"请求成功";
    if (self.page <= 1) {
        [self initArrWithDic:data[@"data"] withParams:params withUrlString:urlString];
    }else{
        [self appendArrWithDic:data[@"data"] withParams:params withUrlString:urlString];
    }
    [self endRefresh:YES];
}
/**
 *  获取model类型
 */
- (JYBasicModel *)getModelWithObj:(id)obj{
    if ([self.dataDelegate respondsToSelector:@selector(getModelWithObj:)]) {
        return [self.dataDelegate getModelWithObj:obj];
    }else{
        return [JYBasicModel new];
    }
}
- (void)setDataArr:(NSMutableArray *)dataArr{
    if(dataArr != nil && dataArr.count > 0){
        self.listArray = dataArr;
        [self.listModel removeAllObjects];
        self.listModel = [self getModelWithArr:dataArr];
        [self reloadData];
        self.mj_header = nil;
        self.mj_footer = nil;
    }
}
/**
 *  获取model数组
 */
- (NSMutableArray *)getModelWithArr:(NSMutableArray *)arr{
    NSMutableDictionary * obj =  nil;
    JYBasicModel * model =  nil;
    NSMutableArray * modelArr = [NSMutableArray new];
    for (int x = 0; x < arr.count; x++) {
        obj = arr[x];
        if (obj) {
            model = [self getModelWithObj:obj];
            [modelArr addObject:model];
        }
    }
    return modelArr;
}
- (void)initArrWithDic:(id )arr
            withParams:(NSMutableDictionary *)params
         withUrlString:(NSString *)urlString{
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:arr];
    self.listModel = [self getModelWithArr:arr];
    
    if (self.mj_header == nil && _isDropDownRefresh) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
    }
    
    if (self.listModel.count == 0 || self.listModel.count < _EPCount) {
        self.mj_footer = nil;
        if (self.listModel.count == 0) {
            [self loadDataFail:arr withParams:params withUrl:urlString];
        }
    }else
    {
        if (self.listModel.count == 0)
        {
            self.mj_header = nil;
            self.mj_footer = nil;
        }
        else
        {
            if (self.mj_footer == nil && _isDropUpRefresh) {
                self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dropUpLoadMore)];
            }
        }
    }
}
- (void)appendArrWithDic:(id )dic
              withParams:(NSMutableDictionary *)params
           withUrlString:(NSString *)urlString{
    NSMutableArray * arr = [dic mutableCopy];
    [self.listArray addObjectsFromArray:arr];
    [self.listModel addObjectsFromArray:[self getModelWithArr:arr]];
    if (arr.count < _EPCount) {
        self.mj_footer = nil;
    }else{
        if (self.mj_footer == nil && _isDropUpRefresh) {
            self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dropUpLoadMore)];
        }
    }
}
- (void)loadDataFail:(id)data withParams:(id)params withUrl:(NSString *)urlString{
    if (data == nil || params == nil || urlString == nil) {
        [self endRefresh:_reqStatus];
        return;
    }
    _loadStatus = @"请求失败";
    [self.listModel removeAllObjects];
    self.emptyView.message = _emptyTitle;
    [self endRefresh:_reqStatus];
}

/**
 *   下拉刷新
 */
- (void)dropDownRefresh{
    if(self.listDelegate && [self.listDelegate respondsToSelector:@selector(dropDownRefresh)]){
        [self.listDelegate dropDownRefresh];
        return;
    }
    self.page = 1;
    [self.reqModel.parameters setObject:WDLTurnIntToString(_page) forKey:@"page"];
    [self loadData];
}
/**
 *  上拉加载
 */
- (void)dropUpLoadMore{
    if(self.listDelegate && [self.listDelegate respondsToSelector:@selector(dropUpLoadMore)]){
        [self.listDelegate dropUpLoadMore];
        return;
    }
    self.page++;
    [self.reqModel.parameters setObject:WDLTurnIntToString(_page) forKey:@"page"];
    [self loadData];
}
- (void)endRefresh:(RequestStatus)status{
    if (status == Req_Success)
    {
        if([self.subviews containsObject:_emptyView]){
            [_emptyView removeFromSuperview];
        }
    }
    else
    {
        if(![self.subviews containsObject:_emptyView]){
            [self addSubview:_emptyView];
        }
    }
    [self updateUI];
}
- (void)updateUI{
    [self reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
/**
 *  空页面展示
 */
- (JYEmptyView *)emptyView{
    if (_emptyView == nil) {
        _emptyView = [[JYEmptyView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    }
    return _emptyView;
}
- (void)setEmptyTitle:(NSString *)emptyTitle{
    if (emptyTitle) {
        self.emptyView.message = emptyTitle;
    }
}
- (NSMutableArray *)listModel  {
    if (!_listModel) {
        _listModel  = [NSMutableArray new];
    }
    return _listModel;
}
- (JYRequesModel *)reqModel{
    if (!_reqModel) {
        _reqModel  = [[JYRequesModel alloc]init];;
    }
    return _reqModel;
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray  = [NSMutableArray new];
    }
    return _listArray;
}

#pragma mark - tableView delegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYBasicCell * cell = nil;
    if ([self.dataDelegate respondsToSelector:@selector(listContentView:cellForRowAtIndexPath:)]) {
        cell = [self.dataDelegate listContentView:self cellForRowAtIndexPath:indexPath];
    }else{
        cell = [self.dataDelegate listContentView:self cellForRowAtIndexPath:indexPath];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //缓存选中的cell
    _currentIndex = indexPath;
    if ([self.dataDelegate respondsToSelector:@selector(listContentView:didSelectRowAtIndexPath:)]) {
        return [self.dataDelegate listContentView:self didSelectRowAtIndexPath:indexPath];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JYBasicModel * model = self.listModel[indexPath.row];
    return MAX(model.cellHeight.floatValue, 10);
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYBasicModel * model = self.listModel[indexPath.row];
    return MAX(model.cellHeight.floatValue, 10);
}

//是否支持编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataDelegate respondsToSelector:@selector(listContentView:canEditRowAtIndexPath:)]) {
        return [self.dataDelegate listContentView:(JYBasicTableView *)tableView canEditRowAtIndexPath:indexPath];
    }else{
        return YES;
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataDelegate respondsToSelector:@selector(listContentView:editingStyleForRowAtIndexPath:)]) {
        return [self.dataDelegate listContentView:(JYBasicTableView *)tableView editingStyleForRowAtIndexPath:indexPath];
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataDelegate respondsToSelector:@selector(listContentView:editActionsForRowAtIndexPath:)]) {
        return [self.dataDelegate listContentView:(JYBasicTableView *)tableView editActionsForRowAtIndexPath:indexPath];
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.dataDelegate respondsToSelector:@selector(headerViewForSection:)]) {
        _headerView = [self.dataDelegate headerViewForSection:self];
        return _headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.dataDelegate respondsToSelector:@selector(heightViewForSectionHeaderView:)]) {
        return [self.dataDelegate heightViewForSectionHeaderView:self];
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.dataDelegate respondsToSelector:@selector(heightViewForSectionFooterView:)]) {
        return [self.dataDelegate heightViewForSectionFooterView:self];
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.dataDelegate respondsToSelector:@selector(footerViewForSection:)]) {
        _footerView = [self.dataDelegate footerViewForSection:self];
        return _footerView;
    }else{
        return nil;
    }
}

-(UIView *)listContentHeaderView:(JYBasicTableView *)tableView{
    if ([self.dataDelegate respondsToSelector:@selector(listContentHeaderView:)]) {
        _tbHeaderView = [self.dataDelegate listContentHeaderView:self];
        return _tbHeaderView;
    }else{
        return nil;
    }
}
-(CGFloat)listContentHeaderHeightView:(JYBasicTableView *)tableView{
    if ([self.dataDelegate respondsToSelector:@selector(listContentHeaderHeightView:)]) {
        return [self.dataDelegate listContentHeaderHeightView:self];
    }else{
        return 0;
    }
}

-(UIView *)listContentFooterView:(JYBasicTableView *)tableView{
    if ([self.dataDelegate respondsToSelector:@selector(listContentFooterView:)]) {
        _tbFooterView = [self.dataDelegate listContentFooterView:self];
        return _tbFooterView;
    }else{
        return nil;
    }
}
-(CGFloat)listContentFooterHeightView:(JYBasicTableView *)tableView{
    if ([self.dataDelegate respondsToSelector:@selector(listContentFooterHeightView:)]) {
        return [self.dataDelegate listContentFooterHeightView:self];
    }else{
        return 0;
    }
}
/**
 *  内存释放
 */
- (void)dealloc{
    if (_isArrowPrintLog) {
        NSLog(@"界面已销毁%@",[self class]);
    }
    self.delegate = nil;
    self.dataSource = nil;
    
    _emptyView = nil;
    _listDelegate = nil;
    _dataDelegate = nil;
    _loadDelegate = nil;
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
