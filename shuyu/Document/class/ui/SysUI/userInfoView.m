//
//  userInfoView.m
//  RTPg
//
//  Created by tts on 2019/4/13.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "userInfoView.h"
#import "loginVC.h"
#import "LeanCloudResModel.h"
#import "LeanCloudInterface.h"

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
        [control addTarget:self action:@selector(clickHeadImage) forControlEvents:UIControlEventTouchDown];
        control.centerY = _headImg.centerY;
        
        wFrame = CGRectMake(CGRectGetMaxX(_headImg.frame) + 15*JYScale_Width, CGRectGetMinY(_headImg.frame) + 15*JYScale_Height, frame.size.width - (CGRectGetMaxX(_headImg.frame) - 15*JYScale_Width), 18*JYScale_Height);
        _userName = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYDeepColor andLabelFont:18*JYScale_Height andLabelFrame:wFrame andJoinView:self];
        _userName.textAlignment = NSTextAlignmentLeft;
        _userName.text = WDLTurnIdToString([LeanCloudResModel shareCloudModel].userInfo[@"username"]);
        
        wFrame = CGRectMake(CGRectGetMinX(_userName.frame), CGRectGetMaxY(_userName.frame) + 10*JYScale_Height, _userName.width, 14*JYScale_Height);
        _userID = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:14*JYScale_Height andLabelFrame:wFrame andJoinView:self];
        _userID.textAlignment = NSTextAlignmentLeft;
        _userID.text = [WDLTurnIdToString([LeanCloudResModel shareCloudModel].userInfo[@"objectId"]) substringToIndex:8];
        
       UIView * lineView = [JYCommonKits getViewLineWithFrame:CGRectMake(0, _headImg.bottom+25*JYScale_Height, frame.size.width, lineSize) andJoinView:self];
        self.height = lineView.bottom;
        
        [self upthumb];
    }
    return self;
}

- (void)updataUI{
    _userID.text = [[LeanCloudResModel shareCloudModel].user.objectId substringToIndex:8];
    _userName.text = [LeanCloudResModel shareCloudModel].user.username;
    
    [self upthumb];
}
- (void)clearUI{
    _userID.text = @"";
    _userName.text = @"未登录";
    [_headImg setImage:[UIImage imageNamed:@"profile_pic"]];
}
- (void)upthumb{
    if ([LeanCloudResModel shareCloudModel].status == NO) {
        return;
    }
    JYWeakify(self);
    [LeanCloudInterface getUserThumbClass:@"headerImage" result:^(BOOL status) {
        if (status) {
            [weakSelf.headImg sd_setImageWithURL:[NSURL URLWithString:[LeanCloudResModel shareCloudModel].model.thumbImg] placeholderImage:defaultImage];
        }else{
            [weakSelf.headImg setImage:defaultImage];
        }
    }];
}

- (void)clickHeadImage{
    if ([self.HD_Delegate respondsToSelector:@selector(clickHeadImage:)] && self.HD_Delegate) {
        [self.HD_Delegate clickHeadImage:self.model];
    }
}

-(void)setModel:(UIHeaderModel *)model{
    _model = model;
    [_headImg sd_setImageWithURL:[NSURL URLWithString:_model.headImg] placeholderImage:defaultImage];
    _userID.text = [model.userID substringToIndex:8];
    _userName.text = model.userName;
}
@end

@implementation UIHeaderModel

@end


//================================================列表================================================
@interface userInfoView ()<infoHeaderDelegate,UIGestureRecognizerDelegate>

@property (strong , nonatomic) NSMutableArray * dataArr;

@property (strong , nonatomic) NSMutableArray * descArr;

@property (strong , nonatomic) NSMutableArray * arrowArr;

@property (strong , nonatomic) NSMutableArray * titleArr;

@property (strong , nonatomic) NSMutableArray * iconArr;

@end
@implementation userInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //数据刷新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:JYLoginStatueChange object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeadImg:) name:JYImageUploadSuccess object:nil];
        
        //侧滑页面
        _contentView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(-2*JYScreenW/3, 0, 2*JYScreenW/3, JYScreenH) andJoinView:self];
        _contentView.backgroundColor = kWhiteColor;
        
        _headerView = [[UIHeaderView alloc]initWithFrame:CGRectMake(0,SafeNaviTopHeight, _contentView.width, 120*JYScale_Height)];
        _headerView.HD_Delegate = self;
        [_contentView addSubview:_headerView];
        
        __block NSMutableDictionary * dic = nil;
        JYWeakify(self);
        __weak typeof(_iconArr) weakIcon = self.iconArr;
        __weak typeof(_titleArr) weakTitle = self.titleArr;
        __weak typeof(_descArr) weakDesc = self.descArr;
        __weak typeof(_arrowArr) weakArrow = self.arrowArr;
        
        [_titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                dic = [NSMutableDictionary new];
                PARAMS(dic, @"img", weakIcon[idx]);
                PARAMS(dic, @"title", weakTitle[idx]);
                PARAMS(dic, @"desc", weakDesc[idx]);
                PARAMS(dic, @"arrow", weakArrow[idx]);
                [weakSelf.dataArr addObject:dic];
            }
        }];

        _infoTBView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,_headerView.bottom, _contentView.width,frame.size.height-_headerView.bottom) withDelegate:self];
        [_infoTBView setDataArr:self.dataArr];
        _infoTBView.tableFooterView =  [JYCommonKits getViewLineWithFrame:CGRectMake(0, 0, JYScreenW, lineSize) andJoinView:nil];
        [_contentView addSubview:_infoTBView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }

    return self;
}
- (void)updateHeadImg:(NSNotification *)noti{
    if([noti.object[@"image"] isKindOfClass:[UIImage class]]){
        [_headerView.headImg setImage:noti.object[@"image"]];
    }
}
- (void)updateData{
    //切换状态改变，先登录，再跟新数据
    if ([LeanCloudResModel shareCloudModel].status == YES) {
        //获取图片地址
        [_headerView updataUI];
    }else{
        [_headerView clearUI];
    }
    
    NSMutableDictionary * dic = self.dataArr[_titleArr.count-1];
    [dic setObject:[LeanCloudResModel shareCloudModel].status?@"退出登录":@"未登录" forKey:@"title"];
    [_infoTBView setDataArr:self.dataArr];
}

#pragma mark init
- (NSMutableArray * )dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

- (NSMutableArray *)arrowArr{
    if (_arrowArr == nil) {
        _arrowArr = [[NSMutableArray alloc]initWithObjects:@(1),@(0),@(1),@(1),@(1),nil];
    }
    return _arrowArr;
}

- (NSMutableArray *)descArr{
    if (_descArr == nil) {
        _descArr = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@",[JYCalulateKits getCacheSize]],WDLTurnIdToString(WDLAppVersion),@"",@"",@"", @"",nil];
    }
    return _descArr;
}
- (NSMutableArray *)iconArr{
    if (_iconArr == nil) {
        _iconArr = [[NSMutableArray alloc]initWithObjects:@"profile_clearcache_icon",@"profile_collect_icon",@"profile_message_icon",@"profile_invite_icon",@"profile_help_icon", @"profile_setting_icon",nil];
    }
    return _iconArr;
}
- (NSMutableArray *)titleArr{
    if (_titleArr == nil) {
        _titleArr = [[NSMutableArray alloc]initWithObjects:@"清理缓存",@"当前版本",@"修改密码",@"关于书语",[LeanCloudResModel shareCloudModel].status?@"退出登录":@"未登录",nil];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = (infoTBModel *)_infoTBView.listModel[indexPath.row];
    return cell;
}

- (void)clickHeadImage:(UIHeaderModel *)model{
    [self removeSelf];
    if ([self.tbDelegate respondsToSelector:@selector(clickHeadImage:)] && self.tbDelegate) {
        [self.tbDelegate clickHeadImage:model];
    }
}

- (void)listContentView:(JYBasicTableView *)listContentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tbDelegate respondsToSelector:@selector(infoTBView:didSelectRowAtIndexPath:)] && self.tbDelegate) {
        [self removeSelf];
        [self.tbDelegate infoTBView:listContentView didSelectRowAtIndexPath:indexPath];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
    }
    return YES;
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
@property (strong , nonatomic) UILabel * desc;
@property (strong , nonatomic) UIImageView * arrowImg;

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
    _lineView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0,0, self.width,tableHeaderSpaceH) andJoinView:self.contentView];
    _lineView.backgroundColor = JYLineColor;
    
    _profileImage = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriWidth, _lineView.bottom+oriHeight, 20*JYScale_Height,20*JYScale_Height) AndSuperView:self.contentView AndImagePath:@"profile_pic"];
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.cornerRadius = CGRectGetHeight(_profileImage.frame)/2;
    
    _title = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYMiddleColor andLabelFont:18*JYScale_Height andLabelFrame:CGRectMake(_profileImage.right+10*JYScale_Width,0, self.width - (_profileImage.right+5*JYScale_Width), 15*JYScale_Width) andJoinView:self.contentView];
    _title.textAlignment = NSTextAlignmentLeft;
    _title.centerY = _profileImage.centerY;
    
    _arrowImg = [JYCommonKits initWithImageViewWithFrame:CGRectMake(JYScreenW*2/3-7*JYScale_Height-10*JYScale_Width, 0, 7*JYScale_Height, 14*JYScale_Height) AndSuperView:self.contentView];
    _arrowImg.centerY = _title.centerY;
    [_arrowImg setImage:[UIImage imageNamed:@"arrow_right"]];
    
    _desc = [JYCommonKits initLabelViewWithLabelDetail:@"" andLabelColor:JYLightColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(0,0, _arrowImg.left-5*JYScale_Width, 14*JYScale_Width) andJoinView:self.contentView];
    _desc.textAlignment = NSTextAlignmentRight;
    _desc.centerY = _profileImage.centerY;

}
-(void)setModel:(infoTBModel *)model{
    _model = model;
    [_profileImage setImage:[UIImage imageNamed:model.img]];
    _title.text = [NSString stringWithFormat:@"%@",model.title];
    
    _desc.text = model.desc;
    _arrowImg.hidden = ![_model.arrow boolValue];
    _model.cellHeight = [NSNumber numberWithFloat:_profileImage.bottom + oriHeight];
    
}
@end

@implementation infoTBModel

@end
