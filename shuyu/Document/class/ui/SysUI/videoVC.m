//
//  videoVC.m
//  ZFPlayer
//
//  Created by 任子丰 on 2018/4/1.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "videoVC.h"

#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/KSMediaPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "ZFPlayerDetailViewController.h"
#import "ZFTableViewCell.h"
#import "ZFTableData.h"
#import <AVFoundation/AVFoundation.h>

static NSString *kIdentifier = @"kIdentifier";

@interface videoVC () <UITableViewDelegate,UITableViewDataSource,ZFTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSString * maxtime;

@end

@implementation videoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    self.hbd_barTintColor = RGBOF(0x1d99f2);
    self.hbd_tintColor = kWhiteColor;
    self.hbd_titleTextAttributes = @{
                                     NSFontAttributeName:JY_Font_Sys(18*JYScale_Height), NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.tableView];
    
    [self dropDownRefresh];
    
    [self playerInit];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat h = CGRectGetMaxY(self.view.frame);
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, h-y);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}
- (void)playerInit{
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    /// 0.8是消失80%时候，默认0.5
    self.player.playerDisapperaPercent = 0.8;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.playingIndexPath.row < self.urls.count - 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else {
            [self.player stopCurrentPlayingCell];
        }
    };
    
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
}
- (void)formattarData:(id)dataDic loadingMore:(BOOL)loadingFirst{
    //是否初次加载
    BOOL isLoaing = loadingFirst;
    
    if (self.urls == nil || self.dataSource == nil) {
        self.urls = @[].mutableCopy;
        self.dataSource = @[].mutableCopy;
        isLoaing = YES;
    }

    if (isLoaing == YES) {
        [self.dataSource removeAllObjects];
        [self.urls removeAllObjects];
    }
    
    new_Array(urls);
    new_Array(dataSources);
    
    NSArray *videoList = [dataDic objectForKey:@"list"];
    for (NSDictionary *dataDic in videoList) {
        ZFTableData *data = [[ZFTableData alloc] init];
        [data setValuesForKeysWithDictionary:dataDic];
        
        ZFTableViewCellLayout *layout = [[ZFTableViewCellLayout alloc] initWithData:data];
        NSString *URLString = [data.videouri stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];

        [dataSources addObject:layout];
        [urls addObject:url];
    }
    
    //加入数据
    [self.urls addObjectsFromArray:urls];
    [self.dataSource addObjectsFromArray:dataSources];
    
    self.player.assetURLs = self.urls;
}

- (void)dropDownRefresh{
    NSMutableDictionary * params=@{@"a":@"list",@"c":@"data",@"type":@"41"}.mutableCopy;
    [self loadDataParams:params complete:nil isFirstLoading:YES];
}
- (void)dropUpLoadMore{
    if(!self.maxtime)return;
    NSMutableDictionary * params=@{@"a":@"list",@"c":@"data",@"type":@"41",@"maxtime":self.maxtime}.mutableCopy;
    [self loadDataParams:params complete:nil isFirstLoading:NO];
}
- (void)updateUI{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
- (void)loadDataParams:(NSMutableDictionary *)params complete:(void (^)(void))complete isFirstLoading:(BOOL)flag{
    @weakify(self)
    [[JYAFNetManager manager] GetWithURL:videoServerUrl Parameters:params Success:^(id success) {
        weak_self.maxtime = WDLTurnIdToString(success[@"info"][@"maxtime"]);
        [weak_self formattarData:success loadingMore:flag];
        [weak_self updateUI];
        if (complete) {
            complete();
        }
    } Failure:^(NSError *error) {
        JYLog(@"加载失败");
        if (complete) {
            complete();
        }
    }];
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate 列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    [cell setDelegate:self withIndexPath:indexPath];
    cell.layout = self.dataSource[indexPath.row];
    [cell setNormalMode];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
//    if (self.player.playingIndexPath != indexPath) {
//        [self.player stopCurrentPlayingCell];
//    }
//    /// 如果没有播放，则点击进详情页会自动播放
//    if (!self.player.currentPlayerManager.isPlaying) {
//        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//    }
//    /// 到详情页
//    ZFPlayerDetailViewController *detailVC = [ZFPlayerDetailViewController new];
//    detailVC.player = self.player;
//    @weakify(self)
//    /// 详情页返回的回调
//    detailVC.detailVCPopCallback = ^{
//        @strongify(self)
//        [self.player updateScrollViewPlayerToCell];
//    };
//    /// 详情页点击播放的回调
//    detailVC.detailVCPlayCallback = ^{
//        @strongify(self)
//        [self zf_playTheVideoAtIndexPath:indexPath];
//    };
//    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    return layout.height;
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    ZFTableViewCellLayout *layout = self.dataSource[indexPath.row];
    [self.controlView showTitle:layout.data.text
                 coverURLString:layout.data.bimageuri
                 fullScreenMode:layout.isVerticalVideo?ZFFullScreenModePortrait:ZFFullScreenModeLandscape];
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZFTableViewCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        
        UIView * lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, 1) andJoinView:nil];
        lineView.backgroundColor = JYLineColor;
        [_tableView setTableHeaderView:lineView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(dropDownRefresh)];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(dropUpLoadMore)];

        // 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

@end

