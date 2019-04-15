//
//  resetPsdVC.m
//  ABCMobileProject
//
//  Created by mmy on 2018/5/17.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "resetPsdVC.h"

@interface resetPsdVC ()

@property (strong , nonatomic) NSMutableDictionary  * submitParams;

@property (strong , nonatomic) UILabel * messageLabel;//短信登录

@property (strong , nonatomic) UILabel * areaCodeLabel;//区域编号

@property (strong , nonatomic) UITextField * phoneLabel;//请输入手机号

@property (strong , nonatomic) UITextField * passwordLabel;//请输入密码或者验证码

@property (strong , nonatomic) UIButton * getVerificationCode;//获取验证码

@property (strong , nonatomic) UIButton * submitBtn;//提交按钮

@property (strong , nonatomic) UIImageView * arrowImg;

@end

@implementation resetPsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    // Do any additional setup after loading the view.
}
- (void)initialize{
 
    CGRect aFrame = WDL_CGMK(10*JYScale_Width,18*JYScale_Height,30*JYScale_Width,48*JYScale_Height);
    UIButton * backBtn = [JYCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:self.view andFrame:aFrame];
    [backBtn setImage:[UIImage imageNamed:@"login_back_btn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchDown];
    
    aFrame = WDL_CGMK(30*JYScale_Width,98*JYScale_Height,40*JYScale_Height,40*JYScale_Height);
    UIImageView * imageView = [JYCommonKits initWithImageViewWithFrame:aFrame AndSuperView:self.view AndImage:[JYCommonKits ImageWithColor:RGB(29.0f, 153.0f, 242.0f) frame:aFrame]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2;
    [imageView setImage:[UIImage imageNamed:@"icon-40"]];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:CGRectGetMaxX(aFrame) + 10*JYScale_Width andOriY:0 andSizeW:100*JYScale_Width andSizeH:0];
    _messageLabel = [JYCommonKits initLabelViewWithLabelDetail:@"重置密码" andLabelColor:kBlackColor andLabelFont:20*JYScale_Height andLabelFrame:aFrame andJoinView:self.view];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    
    NSString * code = [NSString stringWithFormat:@"中国 +86%@",_number];
    CGSize size = [WDLUsefulKitModel stringSize:code font:JY_Font_Sys(16*JYScale_Height) width:JYScreenW];
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) + 37*JYScale_Height andSizeW:size.width andSizeH:20*JYScale_Height];
    _areaCodeLabel = [JYCommonKits initLabelViewWithLabelDetail:code andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andLabelFrame:aFrame andJoinView:self.view];
    _areaCodeLabel.textAlignment = NSTextAlignmentLeft;
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:CGRectGetMaxX(aFrame) + 5*JYScale_Width andOriY:0 andSizeW:7*JYScale_Height andSizeH:14*JYScale_Height];
    _arrowImg = [JYCommonKits initWithImageViewWithFrame:aFrame AndSuperView:self.view AndImagePath:@"login_country_more"];
    _arrowImg.center = CGPointMake(_arrowImg.center.x, _areaCodeLabel.center.y);
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _phoneLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"8-16位(需同时包含字母与数字)" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:self.view];
    [_phoneLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.secureTextEntry = YES;
    _phoneLabel.keyboardType = UIKeyboardTypeASCIICapable;
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    [JYCommonKits getViewLineWithFrame:aFrame andJoinView:self.view];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _passwordLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"请再次输入密码" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:self.view];
    _passwordLabel.textAlignment = NSTextAlignmentLeft;
    [_passwordLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _passwordLabel.secureTextEntry = YES;
    _passwordLabel.keyboardType = UIKeyboardTypeASCIICapable;

    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    [JYCommonKits getViewLineWithFrame:aFrame andJoinView:self.view];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 36*JYScale_Height andSizeW:315*JYScale_Width andSizeH:44*JYScale_Height];
    _submitBtn = [JYCommonKits initButtonnWithButtonTitle:@"完成" andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andSuperView:self.view andFrame:aFrame];
    [_submitBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [_submitBtn setBackgroundColor:RGB(184.0f , 194.0f , 204.0f )];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 22;
}

- (NSMutableDictionary  *)submitParams{
    if (_submitParams == nil) {
        _submitParams = [[NSMutableDictionary alloc]init];
    }
    return _submitParams;
}
- (void)backBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

//短信验证
- (void)loginAction:(UIButton *)sender{

}

//监听输入状态
- (void)textValueChanged{
    if (_phoneLabel.text.length != 0 && _passwordLabel.text.length != 0) {
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = RGB(29.0f, 153.0f, 242.0f);
    }else{
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = RGB(184.0f, 194.0f, 204.0f);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
