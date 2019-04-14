//
//  userInfoView.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/13.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "userInfoView.h"
#import "loginVC.h"

#define ori

//===============================================头部===================================================================

@implementation UIHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
//       _headImg = [JYCommonKits  initWithImageViewWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) AndSuperView:<#(UIView *)#>]
    }
    return self;
}

@end

@implementation UIHeaderModel

@end


//================================================列表================================================

@implementation userInfoView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _headerView = [[UIHeaderView alloc]initWithFrame:CGRectMake(0,0, JYScreenW, 40*JYScale_Height)];
        [self addSubview:_headerView];
        
        new_Array(titleArr);
        new_Array(titleArr);
        
        _infoTBView = [[JYBasicTableView alloc]initWithFrame:CGRectMake(0,0, JYScale_Width * 2/3,self.height) withDelegate:self];
        _infoTBView setDataArr:<#(NSMutableArray *)#>
        [self addSubview:_infoTBView];
    }
    return self;
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
- (void)shareUserInfo{
    [UIView animateWithDuration:0.3 animations:^{
        
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
@property (strong , nonatomic) UILabel * author;
@property (strong , nonatomic) UILabel * content;

@property (strong , nonatomic) ABACellImageView * imageBodyView;

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
-(void)setModel:(infoTBModel *)model{
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

@implementation infoTBModel

@end
