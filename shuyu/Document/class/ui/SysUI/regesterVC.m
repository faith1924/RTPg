//
//  regesterVC.m
//  ABCMobileProject
//
//  Created by mmy on 2018/5/17.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "regesterVC.h"
#import "LeanCloudInterface.h"

#define spaceW 20*JYScale_Width

@interface regesterVC ()

@property (strong , nonatomic) NSMutableDictionary  * submitParams;

@property (strong , nonatomic) UILabel * messageLabel;//短信登录

@property (strong , nonatomic) UILabel * areaCodeLabel;//区域编号

@property (strong , nonatomic) UITextField * userNameLabel;//请输入手机号

@property (strong , nonatomic) UITextField * emailLabel;//请输入手机号

@property (strong , nonatomic) UITextField * passwordLabel;//请输入密码或者验证码

@property (strong , nonatomic) UITextField * passwordAgain;//请输入密码或者验证码

@property (strong , nonatomic) UIButton * getVerificationCode;//获取验证码

@property (strong , nonatomic) UIButton * submitBtn;//提交按钮

@property (strong , nonatomic) UIImageView * arrowImg;

@end

@implementation regesterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户注册";
    [self initialize];
    // Do any additional setup after loading the view.
}
- (void)initialize{
    CGRect aFrame= WDL_CGMK(spaceW,98*JYScale_Height-SafeAreaTopHeight,40*JYScale_Height,40*JYScale_Height);
    UIImageView * imageView = [JYCommonKits initWithImageViewWithFrame:aFrame AndSuperView:nil AndImage:[JYCommonKits ImageWithColor:RGB(29.0f, 153.0f, 242.0f) frame:aFrame]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2;
    [imageView setImage:[UIImage imageNamed:@"icon-40"]];
    [self addSubview:imageView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:CGRectGetMaxX(aFrame) + 10*JYScale_Width andOriY:0 andSizeW:100*JYScale_Width andSizeH:0];
    _messageLabel = [JYCommonKits initLabelViewWithLabelDetail:@"欢迎您" andLabelColor:JYMiddleColor andLabelFont:20*JYScale_Height andLabelFrame:aFrame andJoinView:nil];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_messageLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _userNameLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入用户名" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    [_userNameLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_userNameLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    UIView * lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];

    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) + 20*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _emailLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入邮箱" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    [_emailLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _emailLabel.textAlignment = NSTextAlignmentLeft;
    _emailLabel.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_emailLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 20*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _passwordLabel = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入密码" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    _passwordLabel.textAlignment = NSTextAlignmentLeft;
    [_passwordLabel addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _passwordLabel.secureTextEntry = YES;
    _passwordLabel.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_passwordLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 20*JYScale_Height andSizeW:315*JYScale_Width andSizeH:40*JYScale_Height];
    _passwordAgain = [JYCommonKits initTextfieldViewWithPlaceholder:@"请再次输入密码" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    _passwordAgain.textAlignment = NSTextAlignmentLeft;
    [_passwordAgain addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    _passwordAgain.secureTextEntry = YES;
    _passwordAgain.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:_passwordAgain];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:30*JYScale_Width andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:315*JYScale_Width andSizeH:1*JYScale_Height];
    lineView =  [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) + 36*JYScale_Height andSizeW:315*JYScale_Width andSizeH:44*JYScale_Height];
    _submitBtn = [JYCommonKits initButtonnWithButtonTitle:@"完成" andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andSuperView:nil andFrame:aFrame];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchDown];
    [_submitBtn setBackgroundColor:RGB(184.0f, 194.0f, 204.0f)];
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.layer.cornerRadius = 22;
    
    [self addSubview:_submitBtn];
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
- (void)submitAction:(UIButton *)sender{
    JYWeakify(self);
    if (![_userNameLabel.text isEqualToString:@""] && ![_emailLabel.text isEqualToString:@""] && ![_passwordLabel.text isEqualToString:@""] && ![_passwordAgain.text isEqualToString:@""]) {
        if ([_passwordAgain.text isEqualToString:_passwordLabel.text]) {
            [LeanCloudInterface userRegesterName:_userNameLabel.text password:_passwordLabel.text email:_emailLabel.text result:^(BOOL status) {
                if (status == YES) {
                    [MBProgressHUD showMessage:@"注册成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:JYLoginStatueChange object:@{@"status":@YES}];
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [MBProgressHUD showMessage:@"注册失败"];
                }
            }];
        }else{
            [MBProgressHUD showMessage:@"输入密码不一致"];
        }
    }else{
        [MBProgressHUD showMessage:@"提交信息有误"];
    }
}

//监听输入状态
- (void)textValueChanged{
    if (_emailLabel.text.length != 0 && _passwordLabel.text.length != 0 && _passwordAgain.text.length != 0) {
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
