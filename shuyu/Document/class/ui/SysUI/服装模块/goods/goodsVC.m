//
//  goodsVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "goodsVC.h"
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
#define btnTag 200
#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1)

@interface goodsVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYTableViewDelegate,userInfoDelegate,TZImagePickerControllerDelegate>
{
    NSArray * typeArr;
    UIButton * tempBtn;
    UIButton * sortTempBtn;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) UIView * headerView;

@property (strong , nonatomic) UILabel * headerLabel;

@property (strong , nonatomic) NSMutableArray * defaultArr;

@property (assign , nonatomic) NSInteger type;//0默认 1在售 2已下架

@end

@implementation goodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self setupUIWithData:nil];
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
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,JYStatusBarHeight, JYScreenW,self.contentView.height - SafeTabbarBottomHeight-JYStatusBarHeight) withDelegate:self];
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

- (goodsCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    goodsCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[goodsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (goodsModel *)_bodyView.listModel[indexPath.row];
    return cell;
}

- (void)dropDownRefresh{
    JYWeakify(self);
    [LeanCloudInterface getClassInfo:@"platformListData" keyDic:@[@"closeListData"] result:^(BOOL status,id object) {
        NSDictionary * dic = object[0][@"closeListData"];
        if (dic != nil) {
            if(weakSelf.headerView){
                weakSelf.headerLabel.text = WDLTurnIdToString(dic[@"category"]);
            }
            //保存正常排序
            weakSelf.defaultArr = [dic[@"list"] mutableCopy];
            
            UIButton * btn = [weakSelf.view viewWithTag:btnTag];
            [weakSelf sortBtnAction:btn];
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

- (goodsModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    goodsModel * model = [[goodsModel alloc]initWithDictionary:obj error:&error];

    if (error) {
        NSLog(@"error = %@",error);
        model = [[goodsModel alloc]init];
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
        
        UIView * vi = nil;
        CGRect tFrame = CGRectZero;
        NSArray * typeArr = @[@"默认",@"在售",@"已下架"];
        float sortBtnWidth = (JYScreenW - oriWidth * (typeArr.count+1))/typeArr.count;
        NSInteger count = typeArr.count>4?4:typeArr.count;
        sortBtnWidth = (JYScreenW - oriWidth * (count+1))/count;
        for(int i = 0; i<typeArr.count; i++){
            tFrame = CGRectMake((oriWidth + sortBtnWidth)*(i%count) + oriWidth, _headerLabel.bottom + (oriWidth + sortViewHeight) * (i/count), sortBtnWidth, sortViewHeight);
            vi = [self creatRankBtnViewFrame:tFrame title:typeArr[i] supView:_headerView andTag:btnTag+i];
        }
        
        _headerView.height = vi.bottom + 2*oriWidth;
    }
    return _headerView;
}

#define titleBtnHeight 40*JYScale_Height
#define sortBtnHeight 30*JYScale_Height

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
    
    if (tag == btnTag) {
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
        
        _type = sender.tag  - btnTag;
    }
    
    NSMutableArray * newArr =  [Close_Db_Object getSortArr:self.defaultArr type:_type];
    
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
#define imageH 80*JYScale_Width

#define fontH 13*JYScale_Height
#define fontSelH 13*JYScale_Height

#define labelWidth ((JYScreenW - oriWidth * 2)/3)

@interface goodsCell ()

@property (strong , nonatomic) UIView * bgView;

@property (strong , nonatomic) UIImageView * img;

@property (strong , nonatomic) UILabel * name;

@property (strong , nonatomic) UILabel * isSalingStr;

@property (strong , nonatomic) UILabel * inPrize;
@property (strong , nonatomic) UILabel * totleCloseNumber;

@end

@implementation goodsCell
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

    _bgView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(oriWidth, 0, JYScreenW - oriWidth*2, cellH) andJoinView:self.contentView];
    _bgView.backgroundColor = cellBgColor;
    
    _img = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, oriWidth, imageH, imageH) AndSuperView:_bgView];
    _name = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:(2*JYScale_Height+labH) andLabelFrame:CGRectMake(_img.right + oriWidth, _img.top, _bgView.width - _img.right - oriWidth*2, 14*JYScale_Height) andJoinView:_bgView];
    _name.numberOfLines = 2;
    
    _isSalingStr = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_name.left, _img.bottom - labH * 2 - 10*JYScale_Height,_name.width, labH) andJoinView:_bgView];

    _totleCloseNumber = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_name.left, _isSalingStr.bottom + 10*JYScale_Height,_name.width/2, labH) andJoinView:_bgView];
    
    _inPrize = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0  andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(_totleCloseNumber.right, _totleCloseNumber.top, _name.width/2, labH) andJoinView:_bgView];

}
-(void)setModel:(goodsModel *)model{
    _model = model;
    
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img] placeholderImage:defaultImage];
    
    _name.text = _model.name;
    [_name sizeToFit];
    _name.top = _img.top;
    
    _totleCloseNumber.text = [NSString stringWithFormat:@"总库存：%@ 件",_model.totleCloseNumber];
    _inPrize.text = [NSString stringWithFormat:@"进价：%@ 元",_model.inPrize];
    _isSalingStr.text = [NSString stringWithFormat:@"是否在售：%@ ",_model.isSalingStr];
    
    if ([model.isSaling intValue] == 1) {
        [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kGreenColor fSize:fontH lastSize:fontSelH lab:_isSalingStr];
    }else{
        [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kRedColor fSize:fontH lastSize:fontSelH lab:_isSalingStr];
    }
    
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kWhiteColor fSize:fontH lastSize:fontSelH lab:_totleCloseNumber];
    [WDLUsefulKitModel labelShowDifColorKey:@"：" frontColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) lastColor:kWhiteColor fSize:fontH lastSize:fontSelH lab:_inPrize];
    
    
    
    _bgView.height = _img.bottom + oriWidth;
    _model.cellHeight = [NSNumber numberWithFloat:_bgView.height];
}
@end

@implementation goodsModel

@end
