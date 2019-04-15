//
//  verificationVC.m
//  ABCMobileProject
//
//  Created by mmy on 2018/5/17.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "verificationVC.h"
#import <SMS_SDK/SMSSDK.h>

#import "resetPsdVC.h"
#import "regesterVC.h"


#define spaceW 30*JYScale_Width

@interface verificationVC (){
    NSTimer * _timer;
    int _validationTime;
}

@property (strong , nonatomic) NSMutableDictionary  * submitParams;

@property (strong , nonatomic) UILabel * messageLabel;//短信登录

@property (strong , nonatomic) UILabel * areaCodeLabel;//区域编号

@property (strong , nonatomic) UITextField * phoneLabel;//请输入手机号

@property (strong , nonatomic) UITextField * passwordLabel;//请输入密码或者验证码

@property (strong , nonatomic) UIButton * getVerificationCode;//获取验证码

@property (strong , nonatomic) UIButton * submitBtn;//提交按钮

@property (strong , nonatomic) UIImageView * arrowImg;

@end

@implementation verificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"短信验证";
    [self initialize];
    // Do any additional setup after loading the view.
}
- (void)initialize{
    CGRect aFrame = WDL_CGMK(30*JYScale_Width,98*JYScale_Height-SafeAreaTopHeight,40*JYScale_Height,40*JYScale_Height);
    UIImageView * imageView = [JYCommonKits initWithImageViewWithFrame:aFrame AndSuperView:nil AndImage:[JYCommonKits ImageWithColor:RGB(29.0f, 153.0f, 242.0f) frame:aFrame]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2;
    [imageView setImage:[UIImage imageNamed:@"icon-40"]];
    [self addSubview:imageView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:CGRectGetMaxX(aFrame) + 10*JYScale_Width andOriY:0 andSizeW:100*JYScale_Width andSizeH:0];
    _messageLabel = [JYCommonKits initLabelViewWithLabelDetail:@"手机验证" andLabelColor:JYMiddleColor andLabelFont:20*JYScale_Height andLabelFrame:aFrame andJoinView:nil];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_messageLabel];
    
    CGSize size = [WDLUsefulKitModel stringSize:@"中国 +86" font:JY_Font_Sys(16*JYScale_Height) width:JYScreenW];
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(imageView.frame) + 37*JYScale_Height andSizeW:size.width andSizeH:20*JYScale_Height];
    _areaCodeLabel = [JYCommonKits initLabelViewWithLabelDetail:@"中国 +86" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andLabelFrame:aFrame andJoinView:nil];
    _areaCodeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_areaCodeLabel];

    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:_areaCodeLabel.bottom + 28*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _phoneLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"输入手机号" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    [_phoneLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.secureTextEntry = NO;
    _phoneLabel.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_phoneLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    UIView * lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    size = [WDLUsefulKitModel stringSize:@"重新获取[1000s]" font:JY_Font_Sys(13*JYScale_Height) width:JYScreenW];
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:JYScreenW - size.width - 30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:size.width andSizeH:40*JYScale_Height];
    _getVerificationCode = [JYCommonKits initButtonnWithButtonTitle:@"获取验证码" andLabelColor:kBlueColor andLabelFont:13*JYScale_Height andSuperView:nil andFrame:aFrame];
    [_getVerificationCode addTarget:self action:@selector(getVerificationCodeAction) forControlEvents:UIControlEventTouchDown];
    _getVerificationCode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:_getVerificationCode];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMinY(aFrame) andSizeW:_getVerificationCode.left - spaceW andSizeH:40*JYScale_Height];
    _passwordLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"输入验证码" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    _passwordLabel.textAlignment = NSTextAlignmentLeft;
    [_passwordLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _passwordLabel.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_passwordLabel];

    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:_passwordLabel.width andSizeH:1*JYScale_Height];
    lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 36*JYScale_Height andSizeW:315*JYScale_Width andSizeH:44*JYScale_Height];
    _submitBtn = [JYCommonKits initButtonnWithButtonTitle:@"提交" andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andSuperView:nil andFrame:aFrame];
    [_submitBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchDown];
    [_submitBtn setBackgroundColor:RGB(184.0f, 194.0f, 204.0f)];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 22;
    _submitBtn.userInteractionEnabled = YES;
    [self addSubview:_submitBtn];
}

- (NSMutableDictionary  *)submitParams{
    if (_submitParams == nil) {
        _submitParams = [[NSMutableDictionary alloc]init];
    }
    return _submitParams;
}

- (void)getVerificationCodeAction{
    if ([_phoneLabel.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"手机号不能为空"];
        return;
    }
    JYWeakify(self);
    //不带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneLabel.text zone:@"86" result:^(NSError *error) {
        if (!error)
        {
            [MBProgressHUD showMessage:@"验证码发送成功"];
            [weakSelf timeInit];
        }
        else
        {
            [MBProgressHUD showMessage:WDLTurnIdToString(error.description)];
        }
    }];
}

- (void)timeInit{
    _validationTime = 60;
    _timer = nil;
    
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
//短信验证
- (void)loginAction:(UIButton *)sender{
    if (self.statusCode == 0) {
        
        new_ControllerWithOutPush(regesterVC);
        controller.number = self.passwordLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if (self.statusCode == 1){
        
        new_ControllerWithOutPush(resetPsdVC);
        controller.number = self.passwordLabel.text;
        [self.navigationController pushViewController:controller animated:YES];
        
    }

    return;
    
    if ([_phoneLabel.text isEqualToString:@""] || [_passwordLabel.text isEqualToString:@""]) {
        return;
    }
    JYWeakify(self);
    [SMSSDK commitVerificationCode:_passwordLabel.text phoneNumber:_phoneLabel.text zone:@"86" result:^(NSError *error) {
        [weakSelf stopValidationTimer];
        if (!error)
        {
            [MBProgressHUD showMessage:@"验证成功"];
            
            if (weakSelf.statusCode == 0) {
                
                new_ControllerWithOutPush(regesterVC);
                controller.number = weakSelf.passwordLabel.text;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            }else if (weakSelf.statusCode == 1){
                
                new_ControllerWithOutPush(resetPsdVC);
                controller.number = weakSelf.passwordLabel.text;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                
            }
        }
        else
        {
            [MBProgressHUD showMessage:WDLTurnIdToString(error.description)];
        }
    }];
}

- (void)countDownAction{
    if (_validationTime > 0) {
        _getVerificationCode.userInteractionEnabled = NO;
        [_getVerificationCode setTitle:[NSString stringWithFormat:@"重新获取[%ds]",_validationTime] forState:UIControlStateNormal];
        [_getVerificationCode setTitleColor:RGB(154.0f, 163.0f , 171.0f) forState:UIControlStateNormal];
        
        _validationTime--;
    }else{
        _getVerificationCode.userInteractionEnabled = YES;
        [_getVerificationCode setTitle:@"重新发送" forState:UIControlStateNormal];
        [_getVerificationCode setTitleColor:RGB(255.0f , 168.0f , 0.0f) forState:UIControlStateNormal];
        [self stopValidationTimer];
    }
}
- (void)stopValidationTimer{
    [_timer invalidate];
    _timer = nil;
}

//监听输入状态
- (void)textValueChanged{
    if (_phoneLabel.text.length != 0 && _passwordLabel.text.length != 0) {
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = RGB(29.0f, 153.0f, 242.0f);
        _submitBtn.userInteractionEnabled = YES;
    }else{
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitBtn.backgroundColor = RGB(184.0f, 194.0f, 204.0f);
        _submitBtn.userInteractionEnabled = NO;
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
