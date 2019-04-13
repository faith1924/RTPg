//
//  jokesVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "jokesVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"

@interface jokesVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYBasicTableViewReqDelegate,JYBasicViewControllerDelegate>
{
    NSMutableArray * typeArr;
    NSMutableArray * titleArr;
    JYRequesModel * tableReqModel;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) UIView * headerView;

@end

@implementation jokesVC

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
    tableReqModel.link = jokeServerUrl;
    [tableReqModel.parameters setObject:PolymerizationJokesKey forKey:@"key"];
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
- (jokesCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    jokesCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[jokesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (jokesModel *)_bodyView.listModel[indexPath.row];
    return cell;
}
#pragma mark 需要重写以下方法
- (void)loadDataSuccess:(id)data withParams:(NSMutableDictionary *)params withUrlString:(NSString *)urlString{
    _bodyView.loadStatus = @"请求成功";
    if (_bodyView.page <= 1) {
        [_bodyView initArrWithDic:data[@"data"] withParams:params withUrlString:urlString];
    }else{
        [_bodyView appendArrWithDic:data[@"data"] withParams:params withUrlString:urlString];
    }
    [_bodyView endRefresh:Req_Success];
}

- (jokesModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    jokesModel * model = [[jokesModel alloc]initWithDictionary:obj error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        model = [[jokesModel alloc]init];
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

@interface jokesCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * content;
@property (strong , nonatomic) UILabel * updateTime;
@end

@implementation jokesCell
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

    _content = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _lineView.bottom + oriHeight, JYScreenW - oriWidth * 2 - imageWidth, 16*JYScale_Height) andJoinView:self.contentView];
    _content.numberOfLines = 0;

    _updateTime = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(oriWidth, oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
}
-(void)setModel:(jokesModel *)model{
    _model = model;

    NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(16*JYScale_Height) withLineSpacing:4 text:model.content];
    _content.attributedText = mutableString;
    [_content sizeToFit];
    [_content setWidth:JYScreenW - oriWidth * 2];

    _updateTime.frame = CGRectMake(_content.left + 10*JYScale_Width, _content.bottom + 10*JYScale_Width, 1, 12*JYScale_Height);
    _updateTime.text = [NSString stringWithFormat:@"更新时间：%@",_model.updatetime];
    [_updateTime sizeToFit];
    [_updateTime setWidth:JYScreenW - oriWidth * 2];
    
    _model.cellHeight = [NSNumber numberWithFloat:_updateTime.bottom + oriHeight];
}
@end

@implementation jokesModel

@end
