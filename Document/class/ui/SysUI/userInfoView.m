//
//  userInfoView.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/13.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "userInfoView.h"
#import "loginVC.h"

#define spaceW 15*JYScale_Width

//===============================================头部===================================================================

@implementation UIHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        CGRect wFrame = CGRectMake(spaceW, 40*JYScale_Height, 70*JYScale_Height, 70*JYScale_Height);
        _headImg = [JYCommonKits initWithImageViewWithFrame:wFrame AndSuperView:self AndImage:defaultImage];
        [_headImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"profile_pic"]];
        _headImg.layer.masksToBounds = YES;
        _headImg.contentMode = UIViewContentModeScaleAspectFill;
        _headImg.layer.cornerRadius = CGRectGetHeight(wFrame)/2;
        
        wFrame = CGRectMake(0, 52*JYScale_Height + SafeNaviTopHeight,JYScreenW/2, 80*JYScale_Height);
        UIControl * control = [JYCommonKits initControlWithFrame:wFrame andJoinView:self];
        [control addTarget:self action:@selector(headerImageAction) forControlEvents:UIControlEventTouchDown];
        control.centerY = _headImg.centerY;
        
        wFrame = CGRectMake(CGRectGetMaxX(_headImg.frame) + 15*JYScale_Width, CGRectGetMinY(_headImg.frame) + 15*JYScale_Height, frame.size.width - (CGRectGetMaxX(_headImg.frame) - 15*JYScale_Width), 18*JYScale_Height);
        _userName = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYDeepColor andLabelFont:18*JYScale_Height andLabelFrame:wFrame andJoinView:self];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.text = @"未登录";
        
        wFrame = CGRectMake(CGRectGetMinX(_userName.frame), CGRectGetMaxY(_userName.frame) + 10*JYScale_Height, _userName.width, 14*JYScale_Height);
        _userID = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:14*JYScale_Height andLabelFrame:wFrame andJoinView:self];
        _userID.textAlignment = NSTextAlignmentLeft;
        _userID.text = @"asdasdasdaasd";
        
       UIView * lineView = [JYCommonKits getViewLineWithFrame:CGRectMake(0, _headImg.bottom+25*JYScale_Height, frame.size.width, lineSize) andJoinView:self];
        self.height = lineView.bottom;
    }
    return self;
}
- (void)headerImageAction{
    
}
-(void)setModel:(UIHeaderModel *)model{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.headImg] placeholderImage:defaultImage];
    _userName.text = _model.userName;
}
@end

@implementation UIHeaderModel

@end


//================================================列表================================================
@interface userInfoView ()

@property (strong , nonatomic) NSMutableArray * dataArr;

@property (strong , nonatomic) NSMutableArray * titleArr;

@property (strong , nonatomic) NSMutableArray * iconArr;

@end
@implementation userInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //侧滑页面
        _contentView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(-2*JYScreenW/3, 0, 2*JYScreenW/3, JYScreenH) andJoinView:self];
        _contentView.backgroundColor = kWhiteColor;
        
        _headerView = [[UIHeaderView alloc]initWithFrame:CGRectMake(0,SafeNaviTopHeight, _contentView.width, 120*JYScale_Height)];
        [_contentView addSubview:_headerView];
        
        __block NSMutableDictionary * dic = nil;
        JYWeakify(self);
        __weak typeof(_iconArr) weakIcon = self.iconArr;
        __weak typeof(_titleArr) weakTitle = self.titleArr;
        [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                dic = [NSMutableDictionary new];
                PARAMS(dic, @"img", weakIcon[idx]);
                PARAMS(dic, @"title", weakTitle[idx]);
                [weakSelf.dataArr addObject:dic];
            }
        }];

        _infoTBView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,_headerView.bottom, _contentView.width,frame.size.height-_headerView.bottom) withDelegate:self];
        [_infoTBView setDataArr:self.dataArr];
        [_contentView addSubview:_infoTBView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
    }

    return self;
}

#pragma mark init
- (NSMutableArray * )dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}
- (NSMutableArray *)iconArr{
    if (_iconArr == nil) {
        _iconArr = [[NSMutableArray alloc]initWithObjects:@"profile_wallet_icon",@"profile_energy_icon",@"profile_collect_icon",@"profile_message_icon",@"profile_invite_icon",@"profile_-online_icon",@"profile_help_icon", @"profile_setting_icon",nil];
    }
    return _iconArr;
}
- (NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"我的资产",@"能量值",@"消息中心",@"收藏/历史",@"邀请好友",@"在线客服",@"帮助/反馈",@"设置", nil];
    }
    return _titleArr;
}

#pragma mark JYTableViewDataSource
- (infoTBCell *)listContentView:(JYBasicTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    infoTBCell * cell = nil;
    static NSString * cellStr = @"cellStr";
    if (cell == nil) {
        cell = [[infoTBCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    cell.model = (infoTBModel *)_infoTBView.listModel[indexPath.row];
    return cell;
}
- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark 需要重写以下方法
- (infoTBModel *)getModelWithObj:(id)obj{
    NSError * error = nil;
    infoTBModel * model = [[infoTBModel alloc]initWithDictionary:obj error:&error];
    
    if (error) {
        NSLog(@"error = %@",error);
        model = [[infoTBModel alloc]init];
    }
    return model;
}

#pragma mark event
- (void)showContentView{
    JYWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.left = 0;
    }];
}
- (void)removeSelf{
    JYWeakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.right = 0;
    }completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
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

@interface infoTBCell ()
@property (strong , nonatomic) UIView * lineView;
@property (strong , nonatomic) UILabel * title;
@property (strong , nonatomic) UIImageView * profileImage;
@end

@implementation infoTBCell
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
    
    _profileImage = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, _lineView.bottom+oriHeight, 20*JYScale_Height,20*JYScale_Height) AndSuperView:self.contentView AndImagePath:@"profile_pic"];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = CGRectGetHeight(_profileImage.frame)/2;
    
    _title = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYMiddleColor andLabelFont:18*JYScale_Height andLabelFrame:CGRectMake(_profileImage.right+10*JYScale_Width,0, self.width - (_profileImage.right+5*JYScale_Width), 15*JYScale_Width) andJoinView:self.contentView];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.centerY = _profileImage.centerY;
}
-(void)setModel:(infoTBModel *)model{
    _model = model;
    [_profileImage setImage:[UIImage imageNamed:model.img]];
    _title.text = [NSString stringWithFormat:@"%@",model.title];
    _model.cellHeight = [NSNumber numberWithFloat:_profileImage.bottom + oriHeight];
}
@end

@implementation infoTBModel

@end
