//
//  loginVC.m
//  RTPg
//
//  Created by md212 on 2019/4/15.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "loginVC.h"
#import "verificationVC.h"
#import "LeanCloudInterface.h"
#import "JYWebViewController.h"

#define spaceW 20*JYScale_Width

@interface loginVC ()<NSCopying,NSMutableCopying>{
    UITextField * account;
    UITextField * password;
    UIButton    * submit;
    UIButton    * getVdCode;
    UIButton    * forgetPsd;
    UILabel     * protocal;
    UIButton    * agreeP;
}

@end

@implementation loginVC
+ (instancetype) shareLoginVC{
    static loginVC * onceTokenVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceTokenVC = [[super allocWithZone:NULL] init];
    });
    return onceTokenVC;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [loginVC shareLoginVC];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [loginVC shareLoginVC];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [loginVC shareLoginVC];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)initView{
    self.navigationItem.title = @"用户登录";
    
    CGRect aFrame = WDL_CGMK(spaceW, 98*JYScale_Height-SafeAreaTopHeight,40*JYScale_Height, 40*JYScale_Height);
    UIImageView * imageView = [JYCommonKits initWithImageViewWithFrame:aFrame AndSuperView:nil];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = CGRectGetHeight(imageView.frame)/2;
    imageView.image = [UIImage imageNamed:@"icon-40"];
    [self addSubview:imageView];

    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:CGRectGetMaxX(aFrame) + 10*JYScale_Width andOriY:0 andSizeW:100*JYScale_Width andSizeH:0];
    UILabel * messageLabel = [JYCommonKits initLabelViewWithLabelDetail:@"账号登录" andLabelColor:JYMiddleColor andLabelFont:18*JYScale_Height andLabelFrame:aFrame andJoinView:nil];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:messageLabel];

    UILabel * _areaCodeLabel = [JYCommonKits initLabelViewWithLabelDetail:@"+86" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andLabelFrame:WDL_CGMK(spaceW, imageView.bottom + 10*JYScale_Height, 1, 1) andJoinView:nil];
    _areaCodeLabel.textAlignment = NSTextAlignmentLeft;
    _areaCodeLabel.font = JY_Font_Sys(14*JYScale_Height);
    [_areaCodeLabel sizeToFit];
    [self addSubview:messageLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:JYScreenW - spaceW*2 andSizeH:40*JYScale_Height];
    account = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入账号" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    [account addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    account.textAlignment = NSTextAlignmentLeft;
    account.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:account];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:JYScreenW - spaceW*2 andSizeH:1];
    UIView * lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:lineView.bottom + 10*JYScale_Height andSizeW:JYScreenW - spaceW*2 andSizeH:40*JYScale_Height];
    password = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入密码" andLabelColor:kBlackColor andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    password.textAlignment = NSTextAlignmentLeft;
    [password addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    password.secureTextEntry = YES;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    [self addSubview:password];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:CGRectGetWidth(password.frame) andSizeH:1];
    lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [self addSubview:lineView];
    
    aFrame = WDL_CGMK(JYScreenW - spaceW - 200*JYScale_Width, lineView.bottom + 10*JYScale_Height, 200*JYScale_Width, 40*JYScale_Height);
    forgetPsd = [JYCommonKits initButtonnWithButtonTitle:@"查看协议" andLabelColor:JYBlueColor andLabelFont:14*JYScale_Height andSuperView:nil andFrame:aFrame];
    [forgetPsd addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    forgetPsd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:forgetPsd];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) + 25*JYScale_Height andSizeW:335*JYScale_Width andSizeH:44*JYScale_Height];
    submit = [JYCommonKits initButtonnWithButtonTitle:@"登录" andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andSuperView:nil andFrame:aFrame];
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundColor:RGB(184.0f, 194.0f,204.0f)];
    submit.layer.masksToBounds = YES;
    submit.layer.cornerRadius = 22;
    submit.userInteractionEnabled = NO;
    [self addSubview:submit];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:agreeP.right andOriY:CGRectGetMaxY(aFrame)+10*JYScale_Height  andSizeW:account.width andSizeH:38*JYScale_Height];
    UIButton * userPro = [JYCommonKits initButtonnWithButtonTitle:@"还没有账号?去注册" andLabelColor:JYBlueColor andLabelFont:12*JYScale_Height andSuperView:nil andFrame:aFrame];
    [userPro addTarget:self action:@selector(regesterAction) forControlEvents:UIControlEventTouchUpInside];
    [agreeP setCenterY:userPro.centerY];
    [self addSubview:userPro];
}

#pragma mark event
- (void)forgetPasswordAction{
    
    new_ControllerWithOutPush(JYWebViewController);
    controller.isCanShare = NO;
    controller.htmlPath = @"protocal";
    [self.navigationController pushViewController:controller animated:YES];
//    new_ControllerWithOutPush(verificationVC);
//    controller.statusCode = 1;
//    [self.navigationController pushViewController:controller animated:YES];
}

- (void)submitAction{
    JYWeakify(self);
    if(![account.text isEqualToString:@""] && ![password.text isEqualToString:@""]){
        [LeanCloudInterface userLoginName:account.text password:password.text result:^(BOOL status) {
            if (status == YES) {
                [MBProgressHUD showMessage:@"登录成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:JYLoginStatueChange object:@{@"status":@YES}];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showMessage:@"登录失败"];
            }
        }];
    }else{
        [MBProgressHUD showMessage:@"用户名和密码都不能为空"];
    }
}

- (void)regesterAction{
    new_ControllerWithOutPush(verificationVC);
    controller.statusCode = 0;
    [self.navigationController pushViewController:controller animated:YES];
}

//监听输入状态
- (void)textValueChanged{
    if (password.text.length != 0 && password.text.length != 0) {
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submit.backgroundColor = RGB(29.0f, 153.0f, 242.0f);
        submit.userInteractionEnabled = YES;
    }else{
        [submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submit.backgroundColor = RGB(184.0f, 194.0f, 204.0f);
        submit.userInteractionEnabled = NO;
    }
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
