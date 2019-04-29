//
//  CGShowVC.m
//  ColorGame
//
//  Created by cyg on 15/12/31.
//  Copyright © 2015年 cyg. All rights reserved.
//

#import "CGShowVC.h"
#import "HHCountdowLabel.h"
#import "JYCommonObjc.h"

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kDifferentColorHex 18 //不同色块跟其他色块颜色初始差值，可以根据不同的关数动态调节难度
#define kTotalTime         30.0f //限定的总时间
//#define limitTime   10.0f //单关总时间
static NSString * collectionViewCellID = @"cellID";

@interface CGShowVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    float limitTime;
    float singleLimitTime;
}
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) UICollectionView * CGCltView;
@property (nonatomic, assign) NSInteger stageLevel;
@property (nonatomic, assign) NSInteger selCgView;
@property (nonatomic, assign) NSInteger passStage;
@property (nonatomic, assign) CGFloat differentColorHex;
@property (nonatomic, strong) NSTimer * CGTimer;
@property (strong , nonatomic) NSMutableDictionary * scoreDic;
@end

@implementation CGShowVC
{
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat sr;
    CGFloat sg;
    CGFloat sb;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self timeLineBg];
    // Do any additional setup after loading the view from its nib.
}
- (void)timeLineBg{
    HHCountdowLabel *countLabel = [[HHCountdowLabel alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    countLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    countLabel.textColor = [UIColor blueColor];
    countLabel.count = 3; //不设置的话，默认是3
    [self.view addSubview:countLabel];
    [countLabel startCount];
    countLabel.complete = ^{
        [self confLevel];
        [self setDefaultState];//设置默认状态
        [self.view addSubview:self.CGCltView];
    };
}
- (void)confLevel{
    _colorGamePlayType = CGGameTypeLimitSingleStageTime;
    if(self.level == CGgameLevelEase){
        limitTime = 10.0f;
        self.navigationItem.title = @"初出茅庐";
    }else if (self.level == CGgameLevelNormal){
        limitTime = 6.0f;
        self.navigationItem.title = @"小有成就";
    }else if (self.level == CGgameLevelHard){
        limitTime = 3.0f;
        self.navigationItem.title = @"登封造极";
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self invalidateTimer];
}
-(void)setDefaultState
{
    if (self.colorGamePlayType == CGGameTypeLimitTotalTime)
    {
        _totalTime = kTotalTime;
        _CGTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAciton:) userInfo:nil repeats:YES];
        self.timeLabel.text = [NSString stringWithFormat:@"倒计时：%.0f秒",_totalTime];
    }
    else if(self.colorGamePlayType == CGGameTypeLimitSingleStageTime)
    {
        _totalTime = limitTime;
        _CGTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAciton:) userInfo:nil repeats:YES];
        self.timeLabel.text = [NSString stringWithFormat:@"倒计时：%.1f秒",_totalTime];
    }
    
    _stageLevel = 2;
    _passStage = 0;
    _differentColorHex = kDifferentColorHex;
    
    [self setRandomRGB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timerAciton:(NSTimer *)timer
{
    if (self.colorGamePlayType == CGGameTypeLimitTotalTime)
    {
        _totalTime = _totalTime - 1;
        if (_totalTime >= 0)
        {
            self.timeLabel.text = [NSString stringWithFormat:@"倒计时：%.0f秒",_totalTime];
        }
        else
        {
            [self selectWrongColor];
        }
    }
    else
    {
        _totalTime = _totalTime - 0.1;
        if (_totalTime >= 0)
        {
            self.timeLabel.text = [NSString stringWithFormat:@"倒计时：%.1f秒",_totalTime];
        }
        else
        {
            [self selectWrongColor];
        }
    }
    

}

-(void)invalidateTimer
{
    if ([_CGTimer isValid])
    {
        [_CGTimer invalidate];
        _CGTimer = nil;
    }
}



#pragma mark - ========= CollectionView Cell =========
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellID forIndexPath:indexPath];
    //随机一个数，作为不同颜色的cell
    
    cell.contentView.backgroundColor = COLOR(r, g, b, 1);
    if (indexPath.row == _selCgView)
    {
        cell.contentView.backgroundColor = COLOR(sr, sg, sb, 1);
    }
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - (_stageLevel+1)*2) / _stageLevel;
    return CGSizeMake(width, width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _stageLevel * _stageLevel;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.contentView.backgroundColor isEqual:COLOR(sr, sg, sb, 1)])
    {
        if (self.colorGamePlayType == CGGameTypeLimitSingleStageTime)
        {
            [self invalidateTimer];
            //重新设置定时器时间
            _totalTime = limitTime;
            _CGTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAciton:) userInfo:nil repeats:YES];
        }
        [self selectRightColor];
    }
    else
    {
        [self selectWrongColor];
    }
    
    
}

-(void)setRandomRGB
{
    r = arc4random()%191 + 30.0;//颜色只取30-220之间的值
    g = arc4random()%191 + 30.0;
    b = arc4random()%191 + 30.0;
    sr = r + _differentColorHex;
    sg = g + _differentColorHex;
    sb = b + _differentColorHex;
    _selCgView = arc4random()%(_stageLevel * _stageLevel);
}

-(void)selectRightColor
{
    NSLog(@"选对了");
    _passStage ++;
    if (_passStage % 4 == 0)
    {
        _stageLevel ++;
    }
    if (_passStage / 4 > 6)
    {
        _differentColorHex = kDifferentColorHex - 3* (_passStage / 4 -6);
    }
    [self setRandomRGB];
    NSLog(@"hex = %f",_differentColorHex);
    [_CGCltView reloadData];
}

-(void)selectWrongColor
{
    NSLog(@"选错了");
    [self invalidateTimer];
    
    __block __weak typeof(self) weakSelf = self;
    [JYCommonObjc setScoreName:[JYCommonObjc getUserName] score:[NSString stringWithFormat:@"%ld",weakSelf.passStage]];
    [JYCommonObjc setScoreRank:weakSelf.passStage];
    [JYCommonObjc setTopArrInfo:weakSelf.passStage];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationUpdataID" object:nil];
    
    NSString * title = [NSString stringWithFormat:@"折戟%ld关",_passStage];
    NSString * message = [NSString stringWithFormat:@"%@",[JYCommonObjc overIndex:_passStage]];

    UIAlertController *alectC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionPlayAgain = [UIAlertAction actionWithTitle:@"再玩一次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setDefaultState];
        [weakSelf.CGCltView reloadData];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alectC addAction:actionPlayAgain];
    [alectC addAction:actionCancel];
    [self presentViewController:alectC animated:NO completion:^{
        
    }];
}

-(UICollectionView *)CGCltView
{
    if (!_CGCltView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _CGCltView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.timeLabel.frame)+20, SCREEN_WIDTH, SCREEN_WIDTH) collectionViewLayout:flowLayout];
        [_CGCltView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellID];
        _CGCltView.delegate = self;
        _CGCltView.dataSource = self;
        _CGCltView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
        _CGCltView.backgroundColor = COLOR(240, 240, 240, 1.0);

    }
    return _CGCltView;
}
- (void)viewWillLayoutSubviews{
    CGRect frame = self.timeLabel.frame;
    frame.origin.y = CGRectGetMinY(_CGCltView.frame) - frame.size.height - 20;
    self.timeLabel.frame = frame;
}
@end
