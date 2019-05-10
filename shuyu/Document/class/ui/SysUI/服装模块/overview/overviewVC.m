//
//  overviewVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "overviewVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"
#import "userInfoView.h"
#import "loginVC.h"
#import "LeanCloudResModel.h"
#import "LeanCloudInterface.h"
#import "TZImagePickerController.h"
#import "verificationVC.h"
#import "comHeadView.h"
#import "Close_Db_Object.h"

#define widthSpace (10*JYScale_Width)
#define btnWidth ((JYScreenW - widthSpace * 3)/2)
#define btnHeight (btnWidth/2)
#define btnArrCount 3
#define titleHeight 50*JYScale_Height

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

@interface overviewVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYTableViewDelegate,userInfoDelegate,TZImagePickerControllerDelegate>
{
    NSArray * typeArr;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) comHeadView * footHeaderView;

@property (strong , nonatomic) UIView * headerView;

@property (strong , nonatomic) UILabel * headerLabel;

@property (strong , nonatomic) UIView * footerView;

@property (strong , nonatomic) UILabel * footerLabel;

@property (strong , nonatomic) userInfoView * infoView;

@property (assign) BOOL status;

@property (strong , nonatomic) TZImagePickerController *imagePickerVc;

@end

@implementation overviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self setupUIWithData:nil];
    // Do any additional setup after loading the view.
}
- (void)dataInit{
    self.contentView.backgroundColor = tabBgColor;
    
    self.hbd_barHidden = YES;
    [self getDefaultConf];
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
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,JYStatusBarHeight, JYScreenW,self.contentView.height - SafeTabbarBottomHeight-JYStatusBarHeight) withDelegate:self];
    _bodyView.isDropUpRefresh = NO;
    _bodyView.isDropDownRefresh = YES;
    _bodyView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyView.backgroundColor = tabBgColor;
    [self addSubview:_bodyView];
}

#pragma mark JYTableViewDataSource
-(UIView *)listContentHeaderView:(JYBasicTableView *)tableView{
    return  self.headerView;
}
-(CGFloat)listContentHeaderHeightView:(JYBasicTableView *)tableView{
    return  self.headerView.height;
}

-(UIView *)headerViewForSection:(JYBasicTableView *)tableView{
    return self.footerView;
}
-(CGFloat)heightViewForSectionHeaderView:(JYBasicTableView *)tableView{
    return self.footerView.height;
}

- (overviewCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    overviewCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[overviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (overviewModel *)_bodyView.listModel[indexPath.row];
    return cell;
}
- (void)getDefaultConf{
    JYWeakify(self);
    [LeanCloudInterface getClassInfo:@"platformListData" keyDic:@[@"info"] result:^(BOOL status,id object) {
        NSDictionary * dic = object[0][@"info"];
        NSMutableDictionary * info = nil;
        if (dic != nil) {
            
            if (weakSelf.headerView) {
                weakSelf.headerLabel.text = WDLTurnIdToString(dic[@"category"]);
            }
            
            NSMutableArray * dataArr = [dic[@"list"] mutableCopy];
            NSArray * titleArr = @[@{@"title":@"昨日销售量",@"subTitle":@"昨日参考收益"},@{@"title":@"本周销售量",@"subTitle":@"本周参考收益"},@{@"title":@"本月销售量",@"subTitle":@"本月参考收益"}];
            NSArray * newArr = @[[Close_Db_Object getSaleData:dataArr day:1],[Close_Db_Object getSaleData:dataArr day:7],[Close_Db_Object getSaleData:dataArr day:30]];
            UIControl * button = nil;
            CGRect tFrame = CGRectMake(widthSpace, titleHeight, btnWidth, btnHeight);
            for (int i = 0; i < [titleArr count]; i++) {
                info = newArr[i];
                button = [self creatBtnTitle:WDLTurnIdToString(titleArr[i][@"title"]) sub:[NSString stringWithFormat:@"%@ 件",info[@"sale"]] frame:tFrame supView:weakSelf.headerView];
                tFrame.origin.x = button.right + widthSpace;
                
                button = [self creatBtnTitle:WDLTurnIdToString(titleArr[i][@"subTitle"]) sub:[NSString stringWithFormat:@"%@ 元",info[@"income"]] frame:tFrame supView:weakSelf.headerView];
                tFrame.origin.x = widthSpace;
                tFrame.origin.y = button.bottom + widthSpace;
            }
        }
    }];
}
- (void)dropDownRefresh{
    JYWeakify(self);
    [LeanCloudInterface getClassInfo:@"platformListData" keyDic:@[@"listData"] result:^(BOOL status,id object) {
        NSDictionary * dic = object[0][@"listData"];
        if (dic != nil) {
            if (weakSelf.footerView) {
                weakSelf.footerLabel.text = WDLTurnIdToString(dic[@"category"]);
            }
            
            [weakSelf loadDataSuccess:dic[@"list"] withParams:nil withUrlString:@""];
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

- (overviewModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    overviewModel * model = [[overviewModel alloc]initWithDictionary:obj error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        model = [[overviewModel alloc]init];
    }
    return model;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, (btnHeight + widthSpace) * btnArrCount) andJoinView:nil];
        UILabel * label = [JYCommonKits initLabelViewWithLabelDetail:@"平台数据" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(widthSpace, 0, _headerView.width - widthSpace, titleHeight) andJoinView:_headerView];
        _headerLabel = label;
        _headerView.height = btnHeight * 3 + widthSpace * 2 + label.height;
    }
    return _headerView;
}

- (UIView *)footerView{
    if(!_footerView){
        _footerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, titleHeight) andJoinView:nil];
        _footerView.backgroundColor = tabBgColor;
        _footerLabel = [JYCommonKits initLabelViewWithLabelDetail:@"平台数据" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(widthSpace, 0, self.footerView.width - widthSpace, titleHeight) andJoinView:_footerView];
        
        _footHeaderView = [[comHeadView alloc]initWithFrame:CGRectMake(widthSpace, _footerLabel.bottom, 0, 0) titleArr:@[@"日期",@"日销量",@"日收益"] iconArr:@[@"icon-40",@"icon-40",@"icon-40"]];
        [_footerView addSubview:_footHeaderView];
        
        _footerView.height = _footHeaderView.bottom;
    }
    return _footerView;
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

#define cellH 50*JYScale_Width
#define oriWidth 10*JYScale_Width
#define labelWidth ((JYScreenW - oriWidth * 2)/3)
@interface overviewCell ()

@property (strong , nonatomic) UIView * bgView;
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * date;
@property (strong , nonatomic) UILabel * sales;
@property (strong , nonatomic) UILabel * income;
@end

@implementation overviewCell
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
    
    _bgView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(oriWidth, 0, JYScreenW - oriWidth*2, cellH + lineSize) andJoinView:self.contentView];
    _bgView.backgroundColor = cellBgColor;
    
    _lineView = [JYCommonKits getViewLineWithFrame:CGRectMake(oriWidth, 0, _bgView.width - oriWidth*2, lineSize) andJoinView:_bgView];
    _lineView.backgroundColor = RGBA(255.0f, 255.0f, 255.0f, 0.2);
    
    _date = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kWhiteColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _lineView.bottom, labelWidth, cellH) andJoinView:_bgView];
    _sales = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:1 andLabelColor:kWhiteColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(_date.right, _date.top, labelWidth, cellH) andJoinView:_bgView];
    _income = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kWhiteColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(_sales.right,_date.top, labelWidth, cellH) andJoinView:_bgView];
}
-(void)setModel:(overviewModel *)model{
    _model = model;
    
    _date.text = _model.dateStr;
    _sales.text = [NSString stringWithFormat:@"%@ 件",_model.sales];
    _income.text = [NSString stringWithFormat:@"¥ %@",_model.income];;
    
    _model.cellHeight = [NSNumber numberWithFloat:_income.bottom];
}
@end

@implementation overviewModel

@end
