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

@interface jokesVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYTableViewDelegate,JYBasicViewControllerDelegate>
{
    NSMutableArray * typeArr;
    NSMutableArray * titleArr;
    JYRequesModel * tableReqModel;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;
@property (strong , nonatomic) NSString * maxtime;
@property (strong , nonatomic) UIView * headerView;

@end

@implementation jokesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.maxtime = nil;
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
    [tableReqModel.parameters setObject:@"29" forKey:@"type"];
    [tableReqModel.parameters setObject:@"data" forKey:@"c"];
    [tableReqModel.parameters setObject:@"list" forKey:@"a"];
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
    self.maxtime  = WDLTurnIdToString(data[@"info"][@"maxtime"]);
    if (self.maxtime == nil) {
        [_bodyView initArrWithDic:data[@"list"] withParams:params withUrlString:urlString];
    }else{
        [_bodyView appendArrWithDic:data[@"list"] withParams:params withUrlString:urlString];
    }
    [_bodyView endRefresh:Req_Success];
}

- (void)dropDownRefresh{
    self.maxtime = nil;
    if([tableReqModel.parameters.allKeys containsObject:@"maxtime"]){
        [tableReqModel.parameters removeObjectForKey:@"maxtime"];
    }
    [self.bodyView loadData];
}
- (void)dropUpLoadMore{
    if(!self.maxtime)return;
    [tableReqModel.parameters setObject:self.maxtime forKey:@"maxtime"];
    [self.bodyView loadData];
}
- (void)updateUI{
    [self.bodyView reloadData];
    [self.bodyView.mj_header endRefreshing];
    [self.bodyView.mj_footer endRefreshing];
}
- (jokesModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    jokesModel * model = [[jokesModel alloc]initWithDictionary:obj error:&error];
    if (error) {
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
#define imageWidth 45*JYScale_Height

@interface jokesCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * content;
@property (strong , nonatomic) UILabel * updateTime;

@property (strong , nonatomic) UILabel * userName;
@property (strong , nonatomic) UIImageView * userImg;
@property (assign , nonatomic) UILabel * like;//点赞量
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
    
    _userImg = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, _lineView.bottom + oriHeight, imageWidth, imageWidth) AndSuperView:self.contentView];
    _userImg.layer.masksToBounds = YES;
    _userImg.layer.cornerRadius = CGRectGetHeight(_userImg.frame)/2;;
    
    _userName = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:kBlackColor andLabelFont:18*JYScale_Height andLabelFrame:CGRectMake(_userImg.right + oriWidth, _userImg.top + 3*JYScale_Height, JYScreenW - oriWidth * 2 - _userImg.right, 18*JYScale_Height) andJoinView:self.contentView];
    _userName.textAlignment = NSTextAlignmentLeft;
    
    _like = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYMiddleColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(_userName.left, _userImg.bottom - 15*JYScale_Height, _userName.width, 12*JYScale_Height) andJoinView:self.contentView];
    _like.textAlignment = NSTextAlignmentLeft;

    _content = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYDeepColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _userImg.bottom + oriHeight * 1.5, JYScreenW - oriWidth * 2 - imageWidth, 16*JYScale_Height) andJoinView:self.contentView];
    _content.numberOfLines = 0;

    _updateTime = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(oriWidth, oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
}
-(void)setModel:(jokesModel *)model{
    _model = model;

    _userName.text = WDLTurnIdToString(_model.name);
    _like.text = [NSString stringWithFormat:@"已有 %@ 喜欢",_model.ding];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:_model.profile_image] placeholderImage:defaultImage];
    
    NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(16*JYScale_Height) withLineSpacing:4 text:model.text];
    _content.attributedText = mutableString;
    [_content sizeToFit];
    [_content setWidth:JYScreenW - oriWidth * 2];

    _updateTime.frame = CGRectMake(_content.left + 10*JYScale_Width, _content.bottom + 10*JYScale_Width, 1, 12*JYScale_Height);
    _updateTime.text = [NSString stringWithFormat:@"更新时间：%@",_model.create_time];
    [_updateTime sizeToFit];
    [_updateTime setWidth:JYScreenW - oriWidth * 2];
    
    _model.cellHeight = [NSNumber numberWithFloat:_updateTime.bottom + oriHeight];
}
@end

@implementation jokesModel

@end
