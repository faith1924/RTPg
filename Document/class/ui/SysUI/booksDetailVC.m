//
//  booksDetailVC.m
//  RTPg
//
//  Created by md212 on 2019/4/11.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "booksDetailVC.h"


#define oriW 15*JYScale_Width
#define oriH 20*JYScale_Width
#define imaH 50*JYScale_Height


@interface booksDetailVC ()

@property (strong , nonatomic) JYBasicTableView * bodyView;

@property (strong , nonatomic) headerView * headView;

@property (strong , nonatomic) UILabel * contentLabel;

@property (strong , nonatomic) UIView * bottomView;

@property (strong , nonatomic) UILabel * catalog;

@property (strong , nonatomic) UIView * segmenttationView;

@end

@implementation booksDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = WDLTurnIdToString(_data[@"title"]);

    [self addSubview:self.headView];
    [self addSubview:self.segmenttationView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.bottomView];
    // Do any additional setup after loading the view.
}

- (UIView * )headView{
    if (_headView == nil) {
        _headView = [[headerView alloc]initWithFrame:CGRectMake(0,0, JYScreenW, 1)];
        
        _headView.image = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriW,oriH,imaH, imaH) AndSuperView:_headView];
        _headView.image.layer.masksToBounds = YES;
        _headView.image.layer.cornerRadius = 4;
        [_headView.image sd_setImageWithURL:[NSURL URLWithString:_data[@"img"]] placeholderImage:defaultImage];
        
        _headView.sub1 = [JYCommonKits initLabelViewWithLabelDetail:_data[@"sub1"] andLabelColor:JYDeepColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(_headView.image.right, _headView.image.top, 1, 16*JYScale_Height) andJoinView:_headView];
        [_headView.sub1 sizeToFit];
        _headView.sub1.top = _headView.image.top;
        _headView.sub1.left = _headView.image.right;
        
        _headView.reading = [JYCommonKits initLabelViewWithLabelDetail:_data[@"reading"] andLabelColor:JYLightColor andLabelFont:12*JYScale_Height andLabelFrame:CGRectMake(_headView.image.right, _headView.image.top, 1, 12*JYScale_Height) andJoinView:_headView];
        [_headView.reading sizeToFit];
        _headView.reading.bottom = _headView.image.bottom;
        _headView.reading.left = _headView.image.right;
        
        _headView.height = _headView.image.bottom + oriW;
        
    }
    return _headView;
}
- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [JYCommonKits initLabelViewWithLabelDetail:WDLTurnIdToString(_data[@"sub2"]) andLabelColor:JYMiddleColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(oriW, _segmenttationView.bottom + oriW, JYScreenW-oriW*2, 1) andJoinView:nil];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;

        NSMutableAttributedString * mutableString = [WDLUsefulKitModel attributedStringFromStingWithFont:JY_Font_Sys(16*JYScale_Height) withLineSpacing:4 text:WDLTurnIdToString(_data[@"sub2"])];
        _contentLabel.attributedText = mutableString;
        [_contentLabel sizeToFit];
        [_contentLabel setWidth:JYScreenW - oriW * 2];
    }
    return _contentLabel;
}

- (UIView *)segmenttationView{
    if(_segmenttationView == nil){
        _segmenttationView = [JYCommonKits getViewLineWithFrame:CGRectMake(0, _headView.bottom, JYScreenW,lineSize) andJoinView:nil];
    }
    return _segmenttationView;
}

- (UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, _contentLabel.bottom, JYScreenW, 40*JYScale_Height) andJoinView:nil];
    }
    return _bottomView;
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

@interface headerView ()

@end

@implementation headerView
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
    }
    return self;
}
@end
