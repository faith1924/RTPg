//
//  plantsVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "plantsVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"
#import "plantsDetailVC.h"

@interface plantsVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYBasicTableViewReqDelegate,JYBasicViewControllerDelegate>
{
    NSMutableArray * typeArr;
    NSMutableArray * titleArr;
    JYRequesModel * tableReqModel;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) ABAHeaderTabView * headerView;

@end

@implementation plantsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfiguraton];
    // Do any additional setup after loading the view.
}
- (void)initConfiguraton{
    self.reqType = 1;
    self.reqModel.link = plantserverUrl;
    [self.reqModel.parameters setObject:@"json" forKey:@"dtype"];
    [self.reqModel.parameters setObject:PolymerizationplantsKey forKey:@"key"];
    
    self.loadDelegate = self;
}
- (void)setupUIWithData:(id)data{
    if (typeArr == nil) {
        typeArr = [NSMutableArray new];
        titleArr = [NSMutableArray new];
    }
    NSMutableDictionary * dic ;
    for (int x = 0; x < [data count]; x++) {
        dic = data[x];
        [typeArr addObject:dic[@"id"]];
        [titleArr addObject:dic[@"catalog"]];
    }
    
    _headerView = [[ABAHeaderTabView alloc]initWithFrame:CGRectMake(0,0, JYScreenW, 40*JYScale_Height)];
    _headerView.titleArr = titleArr;
    _headerView.headerTabViewDelegate = self;
    [self addSubview:_headerView];
    
    tableReqModel = [[JYRequesModel alloc]init];
    tableReqModel.reqType = 1;
    tableReqModel.link = bookListServerUrl;
    [tableReqModel.parameters setObject:PolymerizationplantsKey forKey:@"key"];
    [tableReqModel.parameters setObject:typeArr[0] forKey:@"catalog_id"];
    [tableReqModel.parameters setObject:@"json" forKey:@"dtype"];
    
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,_headerView.bottom, JYScreenW,self.contentView.height - _headerView.height - SafeTabbarBottomHeight) withDelegate:self];
    
    [self addSubview:_bodyView];
}

#pragma mark标题按钮
- (void)headerTabView:(ABAHeaderTabView *)headerTabView didSelectRowAtIndexPath:(NSInteger )indexPath{
    [self.bodyView.reqModel.parameters setObject:typeArr[indexPath] forKey:@"catalog_id"];
    [self.bodyView dropDownRefresh];
}

#pragma mark JYBasicViewControllerDelegate
- (JYRequesModel *)getVCReqModel{
    return self.reqModel;
}

#pragma mark JYTableViewListDelegate
- (JYRequesModel *)getReqModel{
    return tableReqModel;
}
#pragma mark JYTableViewDataSource
- (plantsCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    plantsCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[plantsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (plantsModel *)_bodyView.listModel[indexPath.row];
    return cell;
}
- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    plantsModel * model = (plantsModel *)_bodyView.listModel[indexPath.row];
    if (model && ![model.title isEqualToString:@""]) {
        new_Dic(data);
        PARAMS(data, @"title", model.title);
        PARAMS(data, @"sub1", model.sub1);
        PARAMS(data, @"sub2", model.sub2);
        PARAMS(data, @"reading", model.reading);
        PARAMS(data, @"img", model.img);
        PARAMS(data, @"catalog", model.catalog);
        
        new_ControllerWithOutPush(plantsDetailVC);
        controller.data = data;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (UIView *)listContentFooterView:(JYBasicTableView *)tableView{
    UIView * lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, tableHeaderSpaceH) andJoinView:nil];
    lineView.backgroundColor = JYLineColor;
    return lineView;
}
#pragma mark 需要重写以下方法
- (plantsModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    plantsModel * model = [[plantsModel alloc]initWithDictionary:obj error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        model = [[plantsModel alloc]init];
    }
    return model;
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

#define oriWidth 10*JYScale_Width
#define oriHeight 18*JYScale_Width
#define imageWidth 70*JYScale_Height

@interface plantsCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * title;
@property (strong , nonatomic) UILabel * sub1;
@property (strong , nonatomic) UIImageView * image;
@property (strong , nonatomic) UILabel * category;
@property (strong , nonatomic) UILabel * reading;

@end

@implementation plantsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    _lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0,0, JYScreenW,tableHeaderSpaceH) andJoinView:self.contentView];
    _lineView.backgroundColor = JYLineColor;
    
    _title = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _lineView.bottom + oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
    _title.numberOfLines = 1;
    
    _sub1 = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYMiddleColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _title.bottom + oriHeight, JYScreenW - oriWidth * 2 - imageWidth, 10) andJoinView:self.contentView];
    _sub1.numberOfLines = 2;
    
    _image = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, _sub1.top, imageWidth,imageWidth) AndSuperView:self.contentView AndImagePath:@"profile_pic@2x"];
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 4;
    
    _category = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0 andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectZero andJoinView:self.contentView];
    _category.numberOfLines = 1;
    
    _reading = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(oriWidth, oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
}
-(void)setModel:(plantsModel *)model{
    _model = model;
    
    NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(16*JYScale_Height) withLineSpacing:4 text:model.title];
    _title.attributedText = mutableString;
    [_title sizeToFit];
    _title.font = JY_Font_Bold(16*JYScale_Height);
    [_title setWidth:JYScreenW - oriWidth * 2];
    
    mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(12*JYScale_Height) withLineSpacing:4 text:model.sub2];
    _sub1.attributedText = mutableString;
    [_sub1 sizeToFit];
    [_sub1 setWidth:JYScreenW - oriWidth * 3 - _image.width];
    
    [_image sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:defaultImage];
    [_image setWidth:_image.height];
    [_image setY:_sub1.top];
    [_image setX:JYScreenW - _image.width - oriWidth];
    
    _category.text = [NSString stringWithFormat:@"%@",model.catalog];
    [_category sizeToFit];
    _category.bottom = _image.bottom;
    _category.left = oriWidth;
    
    _reading.frame = CGRectMake(_category.right + 10*JYScale_Width, _title.bottom + 10*JYScale_Width, _title.width, 12*JYScale_Height);
    _reading.text = _model.reading;
    [_reading sizeToFit];
    [_reading setCenterY:_category.centerY];
    
    model.cellHeight = [NSNumber numberWithFloat:_image.bottom + 10*JYScale_Width];
}
@end

@implementation plantsModel

@end
