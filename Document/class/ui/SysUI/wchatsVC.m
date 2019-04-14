//
//  wchatsVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "wchatsVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"

@interface wchatsVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYBasicTableViewReqDelegate,JYBasicViewControllerDelegate>
{
    NSMutableArray * typeArr;
    NSMutableArray * titleArr;
    JYRequesModel * tableReqModel;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) UIView * headerView;

@end

@implementation wchatsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIWithData:nil];
    // Do any additional setup after loading the view.
}
- (void)setupUIWithData:(id)data{
    _headerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, JYScreenW, 1) andJoinView:nil];
    _headerView.backgroundColor = JYLineColor;
    [self addSubview:_headerView];
    
    tableReqModel = [[JYRequesModel alloc]init];
    tableReqModel.reqType = 1;
    tableReqModel.link = wchatsServerUrl;
    [tableReqModel.parameters setObject:PolymerizationWchatsKey forKey:@"key"];
    [tableReqModel.parameters setObject:@"20" forKey:@"pagesize"];
    [tableReqModel.parameters setObject:@"1" forKey:@"page"];
    
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,_headerView.bottom, JYScreenW,self.contentView.height - _headerView.height - SafeTabbarBottomHeight) withDelegate:self];
    [self addSubview:_bodyView];
}

#pragma mark JYTableViewListDelegate
- (JYRequesModel *)getReqModel{
    return tableReqModel;
}
#pragma mark JYTableViewDataSource
- (wchatsCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    wchatsCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[wchatsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (wchatsModel *)_bodyView.listModel[indexPath.row];
    return cell;
}

- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    wchatsModel * model = (wchatsModel *)_bodyView.listModel[indexPath.row];
    
    if (model && ![model.url isEqualToString:@""]) {
        new_ControllerWithOutPush(JYWebViewController);
        controller.urlString = model.url;
        controller.shareThumbnail = @"";
        controller.shareBrief = model.source;
        controller.shareTitle = model.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark 需要重写以下方法
- (void)loadDataSuccess:(id)data withParams:(NSMutableDictionary *)params withUrlString:(NSString *)urlString{
    _bodyView.loadStatus = @"请求成功";
    if (_bodyView.page <= 1) {
        [_bodyView initArrWithDic:data[@"list"] withParams:params withUrlString:urlString];
    }else{
        [_bodyView appendArrWithDic:data[@"list"] withParams:params withUrlString:urlString];
    }
    [_bodyView endRefresh:Req_Success];
}

- (wchatsModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    wchatsModel * model = [[wchatsModel alloc]initWithDictionary:obj error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        model = [[wchatsModel alloc]init];
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
#define oriHeight 10*JYScale_Width
#define imageWidth 70*JYScale_Height

@interface wchatsCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * content;
@property (strong , nonatomic) UILabel * updateTime;
@end

@implementation wchatsCell
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
    
    _content = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kBlackColor andLabelFont:18*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _lineView.bottom + oriHeight, JYScreenW - oriWidth * 2 - imageWidth, 16*JYScale_Height) andJoinView:self.contentView];
    _content.numberOfLines = 0;
    
    _updateTime = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(oriWidth, oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
    _updateTime.textAlignment = NSTextAlignmentLeft;
}
-(void)setModel:(wchatsModel *)model{
    _model = model;
    
    NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(16*JYScale_Height) withLineSpacing:4 text:model.title];
    _content.attributedText = mutableString;
    [_content sizeToFit];
    [_content setWidth:JYScreenW - oriWidth * 2];
    
    _updateTime.frame = CGRectMake(_content.left, _content.bottom + 10*JYScale_Width, 1, 12*JYScale_Height);
    _updateTime.text = [NSString stringWithFormat:@"摘自：%@",_model.source];
    [_updateTime sizeToFit];
    [_updateTime setWidth:JYScreenW - oriWidth * 2];
    
    _model.cellHeight = [NSNumber numberWithFloat:_updateTime.bottom + oriHeight];
}
@end

@implementation wchatsModel

@end
