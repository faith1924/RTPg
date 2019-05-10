//
//  cashsVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "cashsVC.h"
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

#define widthSpace (10*JYScale_Width)
#define btnWidth ((JYScreenW - widthSpace * 3)/2)
#define btnHeight (btnWidth/2)
#define btnArrCount 3
#define titleHeight 50*JYScale_Height

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

@interface cashsVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYTableViewDelegate,userInfoDelegate,TZImagePickerControllerDelegate>
{
    NSArray * typeArr;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) UILabel * headerLabel;

@property (strong , nonatomic) UIView * footerView;

@property (strong , nonatomic) UILabel * footerLabel;

@property (strong , nonatomic) userInfoView * infoView;

@property (assign) BOOL status;

@property (strong , nonatomic) TZImagePickerController *imagePickerVc;

@property (strong , nonatomic) comHeadView * headerView;

@end

@implementation cashsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self setupUIWithData:nil];
    // Do any additional setup after loading the view.
}
- (void)dataInit{
    self.contentView.backgroundColor = tabBgColor;
    
    self.hbd_barHidden = YES;
    self.hbd_barTintColor = tabBgColor;
    self.hbd_tintColor = kWhiteColor;
    self.hbd_titleTextAttributes = @{
                                     NSFontAttributeName:JY_Font_Sys(18*JYScale_Height), NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };

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
-(UIView *)headerViewForSection:(JYBasicTableView *)tableView{
    return self.footerView;
}
-(CGFloat)heightViewForSectionHeaderView:(JYBasicTableView *)tableView{
    return self.footerView.height;
}

- (cashsCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cashsCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[cashsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (cashsModel *)_bodyView.listModel[indexPath.row];
    return cell;
}

- (void)dropDownRefresh{
    JYWeakify(self);
    [LeanCloudInterface getClassInfo:@"platformListData" keyDic:@[@"incomeList"] result:^(BOOL status,id object) {
        NSDictionary * dic = object[0][@"incomeList"];
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

- (cashsModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    cashsModel * model = [[cashsModel alloc]initWithDictionary:obj error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        model = [[cashsModel alloc]init];
    }
    return model;
}
- (UIView *)footerView{
    if(!_footerView){
        _footerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, titleHeight) andJoinView:nil];
        _footerView.backgroundColor = tabBgColor;
        _footerLabel = [JYCommonKits initLabelViewWithLabelDetail:@"平台数据" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(widthSpace, 0, self.footerView.width - widthSpace, titleHeight) andJoinView:_footerView];
        
        _headerView = [[comHeadView alloc]initWithFrame:CGRectMake(widthSpace, _footerLabel.bottom, 0, 0) titleArr:@[@"日期",@"总流水",@"总成本"] iconArr:@[@"icon-40",@"icon-40",@"icon-40"]];
        [_footerView addSubview:_headerView];
        
        _footerView.height = _headerView.bottom;
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
@interface cashsCell ()

@property (strong , nonatomic) UIView * bgView;
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * date;
@property (strong , nonatomic) UILabel * sales;
@property (strong , nonatomic) UILabel * totalOutcome;
@end

@implementation cashsCell
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
    _totalOutcome = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kWhiteColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(_sales.right,_date.top, labelWidth, cellH) andJoinView:_bgView];
}
-(void)setModel:(cashsModel *)model{
    _model = model;
    
    _date.text = _model.dateStr;
    _sales.text = [NSString stringWithFormat:@"¥ %@",_model.totalIncome];
    _totalOutcome.text = [NSString stringWithFormat:@"¥ %@",_model.totalOutcome];
    
    _model.cellHeight = [NSNumber numberWithFloat:_totalOutcome.bottom];
}
@end

@implementation cashsModel

@end
