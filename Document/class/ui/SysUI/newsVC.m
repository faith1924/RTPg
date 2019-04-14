//
//  newsVC.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "newsVC.h"
#import "ABAHeaderTabView.h"
#import "ABACellImageView.h"
#import "JYWebViewController.h"
#import "userInfoView.h"

@interface newsVC ()<JYTableViewDataSource,ABAHeaderTabViewDelegate,JYBasicTableViewReqDelegate>
{
    NSArray * typeArr;
}

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) ABAHeaderTabView * headerView;

@property (strong , nonatomic) userInfoView * infoView;

@end

@implementation newsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    [self setupUIWithData:nil];
    // Do any additional setup after loading the view.
}
- (void)viewInit{
    UIImage * leftImage = [UIImage imageNamed:@"index_menu"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(shareUserInfo)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
}
- (void)setupUIWithData:(id)data{
    typeArr = @[@"top",@"shehui",@"guonei",@"guoji",@"yule",@"tiyu",@"junshi",@"keji",@"caijing",@"shishang"];
 
    self.reqModel.link = newsServerUrl;
    [self.reqModel.parameters setObject:PolymerizationNewsKey forKey:@"key"];
    [self.reqModel.parameters setObject:@"top" forKey:@"type"];
    
    _headerView = [[ABAHeaderTabView alloc]initWithFrame:CGRectMake(0,0, JYScreenW, 40*JYScale_Height)];
    _headerView.titleArr = @[@"头条",@"社会",@"国内",@"国际",@"娱乐",@"体育",@"军事",@"科技",@"财经",@"时尚"].mutableCopy;
    _headerView.headerTabViewDelegate = self;
    [self addSubview:_headerView];
    
    _bodyView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,_headerView.bottom, JYScreenW,self.contentView.height - _headerView.height - SafeTabbarBottomHeight) withDelegate:self];
    [self addSubview:_bodyView];
}

#pragma mark标题按钮
- (void)headerTabView:(ABAHeaderTabView *)headerTabView didSelectRowAtIndexPath:(NSInteger )indexPath{
    [self.reqModel.parameters setObject:typeArr[indexPath] forKey:@"type"];
    [self.bodyView dropDownRefresh];
}

#pragma mark JYTableViewListDelegate
- (JYRequesModel *)getReqModel{
    return self.reqModel;
}
#pragma mark JYTableViewDataSource
- (newsCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    newsCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[newsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (newsModel *)_bodyView.listModel[indexPath.row];
    return cell;
}
- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    newsModel * model = (newsModel *)_bodyView.listModel[indexPath.row];
    
    if (model && ![model.url isEqualToString:@""]) {
        new_ControllerWithOutPush(JYWebViewController);
        controller.urlString = model.url;
        controller.shareThumbnail = ([model.imageArr count]>0?([NSString stringWithFormat:@"%@",model.imageArr[0]]):@"");
        controller.shareBrief = @"点击更精彩...";
        controller.shareTitle = model.title;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark 需要重写以下方法
- (newsModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    newsModel * model = [[newsModel alloc]initWithDictionary:obj error:&error];
    
    //添加配图
    if (model.thumbnail_pic_s) {
        [model.imageArr addObject:model.thumbnail_pic_s];
    }
    if (model.thumbnail_pic_s02) {
        [model.imageArr addObject:model.thumbnail_pic_s02];
    }
    if (model.thumbnail_pic_s03) {
        [model.imageArr addObject:model.thumbnail_pic_s03];
    }
    if (error) {
        NSLog(@"error = %@",error);
        model = [[newsModel alloc]init];
    }
    return model;
}
#pragma mark event
- (void)shareUserInfo{
    [WDLGetKeyWindow addSubview:self.infoView];
}

#pragma mark 懒加载
- (userInfoView * )infoView{
    if(!_infoView){
        _infoView = [[userInfoView alloc]initWithFrame:CGRectMake(0, 0, JYScale_Width, JYScale_Height)];
        _infoView.backgroundColor = RGBA(0, 0, 0, 0.2);
    }
    return _infoView;
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
#define oriHeight 15*JYScale_Width

@interface newsCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * title;
@property (strong , nonatomic) UIImageView * profileImage;
@property (strong , nonatomic) UILabel * author;
@property (strong , nonatomic) UILabel * content;

@property (strong , nonatomic) ABACellImageView * imageBodyView;

@end

@implementation newsCell
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
    
    _title = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYDeepColor andLabelFont:18*JYScale_Height andLabelFrame:CGRectMake(oriWidth, _lineView.bottom + oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
    _title.numberOfLines = 2;
    
    _profileImage = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, _title.bottom, 20*JYScale_Height,20*JYScale_Height) AndSuperView:self.contentView AndImagePath:@"profile_pic@2x"];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = CGRectGetHeight(_profileImage.frame)/2;
    
    _author = [JYCommonKits initLabelViewWithLabelDetail:@"" andTextAlignment:0 andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectZero andJoinView:self.contentView];
    
    _content = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYMiddleColor andLabelFont:20*JYScale_Height andLabelFrame:CGRectMake(oriWidth, oriHeight, JYScreenW - oriWidth * 2, 10) andJoinView:self.contentView];
    
    _imageBodyView = [[ABACellImageView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, 1)];
    [self.contentView addSubview:_imageBodyView];
}
-(void)setModel:(newsModel *)model{
    _model = model;
    
    NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(18*JYScale_Height) withLineSpacing:4 text:model.title];
    _title.attributedText = mutableString;
    [_title sizeToFit];
    [_title setWidth:JYScreenW - oriWidth * 2];

    [_profileImage sd_setImageWithURL:[NSURL URLWithString:model.thumbnail_pic_s] placeholderImage:defaultImage];
    [_profileImage setWidth:_profileImage.height];
    [_profileImage setY:_title.bottom];
    [_author setX:_profileImage.right];
    
    _author.text = [NSString stringWithFormat:@"%@",model.date];
    _author.frame = CGRectMake(_profileImage.right + 10*JYScale_Width, _title.bottom + 10*JYScale_Width, _title.width, 12*JYScale_Height);
    [_profileImage setCenterY:_author.centerY];
    
    [_imageBodyView setY:_author.bottom + 5*JYScale_Width];
    _imageBodyView.imageUrlArr = model.imageArr;

    model.cellHeight = [NSNumber numberWithFloat:_imageBodyView.bottom + 10*JYScale_Width];
}
@end

@implementation newsModel
- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}
@end
