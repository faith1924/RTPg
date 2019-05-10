//
//  qualitysVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "qualitysVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"
#import "userInfoView.h"
#import "loginVC.h"
#import "LeanCloudResModel.h"
#import "LeanCloudInterface.h"
#import "TZImagePickerController.h"
#import "verificationVC.h"
#import "Close_Db_Object.h"

#define oriWidth 10*JYScale_Width
#define widthSpace (10*JYScale_Width)
#define btnWidth ((JYScreenW - widthSpace * 3)/2)
#define btnHeight (btnWidth/2)
#define btnArrCount 3
#define titleHeight 50*JYScale_Height

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1)

@interface qualitysVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYTableViewDelegate,userInfoDelegate,TZImagePickerControllerDelegate>
{
    NSArray * typeArr;
    UIButton * tempBtn;
    UIButton * sortTempBtn;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) UIView * headerView;

@property (strong , nonatomic) UILabel * headerLabel;

@property (strong , nonatomic) NSMutableArray * defaultArr;

@property (assign , nonatomic) NSInteger tampStr;

@property (strong , nonatomic) NSString * sortKey;

@end

@implementation qualitysVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIWithData:nil];
    [self dataInit];
    // Do any additional setup after loading the view.
}
- (void)dataInit{
    self.contentView.backgroundColor = tabBgColor;
    self.hbd_barHidden = YES;
    [self dropDownRefresh];
}

- (UIControl *)creatBtnTitle:(NSString *)title
                         sub:(NSString *)subTitle
                       frame:(CGRect)tframe
                     supView:(UIView *)supV
{
    float titleH = 14*JYScale_Height;
    float subH = 18*JYScale_Height;
    float oriY = (tframe.size.height - titleH - subH)/3;
    UIControl * control = [JYCommonKits initControlWithFrame:tframe andJoinView:supV];
    control.backgroundColor = cellBgColor;
    control.layer.masksToBounds = YES;
    control.layer.cornerRadius = 4;
    
    UILabel * titleLab = [JYCommonKits initLabelViewWithLabelDetail:title
                                                   andTextAlignment:1
                                                      andLabelColor:RGBA(255.0f, 255.0f, 255.0f, 0.4)
                                                       andLabelFont:titleH
                                                      andLabelFrame:CGRectMake(0, oriY, control.width, titleH)
                                                        andJoinView:control];
    [JYCommonKits initLabelViewWithLabelDetail:subTitle
                              andTextAlignment:1
                                 andLabelColor:kWhiteColor
                                  andLabelFont:subH
                                 andLabelFrame:CGRectMake(0, titleLab.bottom + oriY, control.width, subH)
                                   andJoinView:control];
    
    return control;
}

- (void)setupUIWithData:(id)data{
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,JYStatusBarHeight, JYScreenW,JYScreenH - SafeTabbarBottomHeight-JYStatusBarHeight) withDelegate:self];
    _bodyView.isDropUpRefresh = NO;
    _bodyView.isDropDownRefresh = YES;
    _bodyView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyView.backgroundColor = tabBgColor;
    [self addSubview:_bodyView];
}

#pragma mark JYTableViewDataSource

-(UIView *)headerViewForSection:(JYBasicTableView *)tableView{
    return self.headerView;
}
-(CGFloat)heightViewForSectionHeaderView:(JYBasicTableView *)tableView{
    return self.headerView.height;
}

- (qualitysCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    qualitysCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[qualitysCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (qualitysModel *)_bodyView.listModel[indexPath.row];
    return cell;
}

- (void)dropDownRefresh{
    JYWeakify(self);
    [LeanCloudInterface getClassInfo:@"platformListData" keyDic:@[@"closeQualityList"] result:^(BOOL status,id object) {
        NSDictionary * dic = object[0];
        if (dic != nil) {
            if (weakSelf.headerView) {
                weakSelf.headerLabel.text = WDLTurnIdToString(dic[@"closeQualityList"][@"category"]);
            }
            //保存正常排序
            weakSelf.defaultArr = [dic[@"closeQualityList"][@"list"] mutableCopy];
            
            UIButton * btn = [weakSelf.view viewWithTag:102];
            weakSelf.tampStr = 0;
            [weakSelf timeBtnAction:btn];
        }
    }];
}
- (void)loadDataSuccess:(id)data withParams:(NSMutableDictionary *)params withUrlString:(NSString *)urlString{
    self.bodyView.loadStatus = @"请求成功";
    if (self.bodyView.page <= 1) {
        [self.bodyView initArrWithDic:data withParams:params withUrlString:urlString];
    }else{
        [self.bodyView appendArrWithDic:data withParams:params withUrlString:urlString];
    }
    [self.bodyView endRefresh:YES];
}

#pragma mark 需要重写以下方法

- (qualitysModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    qualitysModel * model = [[qualitysModel alloc]initWithDictionary:obj error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        model = [[qualitysModel alloc]init];
    }
    return model;
}

#define timeViewHeight 40*JYScale_Height
#define sortViewHeight 30*JYScale_Height

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, titleHeight) andJoinView:nil];
        _headerView.backgroundColor = tabBgColor;
        _headerLabel = [JYCommonKits initLabelViewWithLabelDetail:@"平台数据" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(widthSpace, 0, _headerView.width - widthSpace, titleHeight) andJoinView:_headerView];
        
        CGRect tFrame = CGRectZero;
        UIView * vi = nil;
        NSArray * timeArr = @[@"7天",@"30天",@"全部"];
        float sortBtnWidth = (JYScreenW - oriWidth * (timeArr.count+1))/timeArr.count;
        for(int i = 0; i<timeArr.count; i++){
            tFrame = CGRectMake((oriWidth + sortBtnWidth) * i + oriWidth, _headerView.bottom + oriWidth/2, sortBtnWidth, timeViewHeight);
            vi = [self creatTimeBtnViewFrame:tFrame title:timeArr[i] supView:_headerView andTag:100+i];
        }
        
        UIView * temp = vi;
        NSArray * typeArr = @[@"默认",@"余量",@"销量",@"退货"];
        NSInteger count = typeArr.count>4?4:typeArr.count;
        sortBtnWidth = (JYScreenW - oriWidth * (count+1))/count;
        for(int i = 0; i<typeArr.count; i++){
            tFrame = CGRectMake((oriWidth + sortBtnWidth)*(i%count) + oriWidth, temp.bottom + oriWidth/2 + (oriWidth + sortViewHeight) * (i/count), sortBtnWidth, sortViewHeight);
            vi = [self creatRankBtnViewFrame:tFrame title:typeArr[i] supView:_headerView andTag:150+i];
        }
        
        _headerView.height = vi.bottom + oriWidth * 2;
    }
    return _headerView;
}

#define titleBtnHeight 40*JYScale_Height
#define sortBtnHeight 30*JYScale_Height

//时间排序
- (UIView * )creatTimeBtnViewFrame:(CGRect)tFrame title:(NSString *)title supView:(UIView *)supView andTag:(NSInteger)tag{
    UIView * vi = [JYCommonKits initializeViewLineWithFrame:tFrame andJoinView:supView];
    
    CGRect aFrame = CGRectMake(0, 10*JYScale_Height, vi.width, sortBtnHeight);
    UIButton * sortBtn = [JYCommonKits initButtonnWithButtonTitle:title andLabelColor:kWhiteColor andLabelFont:12*JYScale_Height andSuperView:vi andFrame:aFrame];
    [sortBtn setBackgroundImage:[JYCommonKits ImageWithColor:RGBA(0, 255.0f, 0, 0.5) frame:aFrame] forState:UIControlStateSelected];
    [sortBtn setBackgroundImage:[JYCommonKits ImageWithColor:cellBgColor frame:aFrame] forState:UIControlStateNormal];
    sortBtn.layer.masksToBounds = YES;
    sortBtn.layer.cornerRadius = 4;
    sortBtn.tag = tag;
    [sortBtn addTarget:self action:@selector(timeBtnAction:) forControlEvents:UIControlEventTouchDown];
    
    if ([title isEqualToString:@"全部"]) {
        tempBtn = sortBtn;
        sortBtn.selected = YES;
    }
    
    return vi;
}
//排序
- (UIView * )creatRankBtnViewFrame:(CGRect)tFrame title:(NSString *)title supView:(UIView *)supView andTag:(NSInteger)tag{
    UIView * vi = [JYCommonKits initializeViewLineWithFrame:tFrame andJoinView:supView];
    
    CGRect aFrame = CGRectMake(0, 10*JYScale_Height, vi.width, sortBtnHeight);
    UIButton * sortBtn = [JYCommonKits initButtonnWithButtonTitle:title andLabelColor:kWhiteColor andLabelFont:12*JYScale_Height andSuperView:vi andFrame:aFrame];
    [sortBtn setBackgroundImage:[JYCommonKits ImageWithColor:RGBA(0, 255.0f, 0, 0.5) frame:aFrame] forState:UIControlStateSelected];
    [sortBtn setBackgroundImage:[JYCommonKits ImageWithColor:cellBgColor frame:aFrame] forState:UIControlStateNormal];
    sortBtn.layer.masksToBounds = YES;
    sortBtn.layer.cornerRadius = 4;
    sortBtn.tag = tag;
    [sortBtn addTarget:self action:@selector(sortBtnAction:) forControlEvents:UIControlEventTouchDown];
    
    if (tag == 150) {
        sortTempBtn = sortBtn;
        sortBtn.selected = YES;
    }
    
    return vi;
}
- (void)sortBtnAction:(UIButton *)sender{
    if (sortTempBtn &&  sender!=nil) {
        sortTempBtn.selected = NO;
        sender.selected = YES;
        sortTempBtn = sender;
    }
    //重新排序
    if (sender.tag == 150) {
        _sortKey = @"";
    }else if (sender.tag == 151){
        _sortKey = @"stock";
    }else if (sender.tag == 152){
        _sortKey = @"sale";
    }else if (sender.tag == 153){
        _sortKey = @"backGoods";
    }
    [self sortUpdateUiTimestamp];
}
- (void)timeBtnAction:(UIButton *)sender{
    if (tempBtn &&  sender!=nil) {
        tempBtn.selected = NO;
        sender.selected = YES;
        tempBtn = sender;
    }

    //重新排序
    if (sender.tag == 100) {
        _tampStr = 86400*7;
    }else if (sender.tag == 101){
        _tampStr = 86400*30;
    }else if (sender.tag == 102){
        _tampStr = 0;
    }
    [self sortUpdateUiTimestamp];
}

- (void)sortUpdateUiTimestamp{
    //获取时间内的
    NSMutableArray * newArr = [Close_Db_Object timeSortDataArr:[self.defaultArr mutableCopy] timestamp:_tampStr];
    
    //重新排序
    [Close_Db_Object quickSortDataArray:newArr startIndex:0 endIndex:newArr.count-1 key:_sortKey];

    //重新刷新页面
    [self loadDataSuccess:newArr withParams:nil withUrlString:@""];
}

- (void)dealloc{
    NSLog(@"已页面销毁");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

#define cellH 130*JYScale_Width
#define imageH 90*JYScale_Width

#define fontH 13*JYScale_Height
#define fontSelH 13*JYScale_Height

#define labelWidth ((JYScreenW - oriWidth * 2)/3)

@interface qualitysCell ()

@property (strong , nonatomic) UIView * bgView;

@property (strong , nonatomic) UIImageView * img;

@property (strong , nonatomic) UILabel * name;
@property (strong , nonatomic) UILabel * resource;

@property (strong , nonatomic) UILabel * sales;
@property (strong , nonatomic) UILabel * stock;

@property (strong , nonatomic) UILabel * backPercent;
@property (strong , nonatomic) UILabel * backGoods;


@end

@implementation qualitysCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    self.backgroundColor = tabBgColor;
    
    float labH = fontH;
    float labSpaceH = (imageH - labH * 4 - 1*JYScale_Height)/3;
    
    _bgView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(oriWidth, 0, JYScreenW - oriWidth*2, cellH) andJoinView:self.contentView];
    _bgView.backgroundColor = cellBgColor;
    
    _img = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, oriWidth, imageH, imageH) AndSuperView:_bgView];
    _name = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:(2*JYScale_Height+labH) andLabelFrame:CGRectMake(_img.right + oriWidth, _img.top, _bgView.width - _img.right - oriWidth*2, labH+1*JYScale_Height) andJoinView:_bgView];
    
    _resource = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_name.left, _name.bottom + labSpaceH ,_name.width, labH) andJoinView:_bgView];
    
    _sales = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_name.left, _resource.bottom + labSpaceH,_name.width/2, labH) andJoinView:_bgView];
    
    _stock = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_sales.left,_sales.bottom + labSpaceH, _name.width/2, labH) andJoinView:_bgView];
    
    _backPercent = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_stock.right, _sales.top ,_name.width/2, labH) andJoinView:_bgView];
    
    _backGoods = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_backPercent.left, _stock.top, _name.width/2, labH) andJoinView:_bgView];
}
-(void)setModel:(qualitysModel *)model{
    _model = model;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:defaultImage];
    
    _name.text = _model.name;
    _resource.text = [NSString stringWithFormat:@"进货渠道：%@",_model.resource];
    _backPercent.text = [NSString stringWithFormat:@"退货比例：%@%%",_model.backPercent];
    _backGoods.text = [NSString stringWithFormat:@"退货数：%@ 件",_model.backGoods];
    _sales.text = [NSString stringWithFormat:@"售出：%@ 件",_model.sale];
    _stock.text = [NSString stringWithFormat:@"余量：%@ 件",_model.stock];
    
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kRedColor fSize:fontH lastSize:fontSelH lab:_resource];
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kRedColor fSize:fontH lastSize:fontSelH lab:_backPercent];
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kRedColor fSize:fontH lastSize:fontSelH lab:_backGoods];
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kGreenColor fSize:fontH lastSize:fontSelH lab:_sales];
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kGreenColor fSize:fontH lastSize:fontSelH lab:_stock];
    
    
    _bgView.height = _img.bottom + oriWidth;
    _model.cellHeight = [NSNumber numberWithFloat:_bgView.height];
}
@end

@implementation qualitysModel

@end
