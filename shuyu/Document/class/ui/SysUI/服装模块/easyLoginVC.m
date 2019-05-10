//
//  easyLoginVC.m
//  RTPg
//
//  Created by md212 on 2019/4/15.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "easyLoginVC.h"
#import "verificationVC.h"
#import "LeanCloudInterface.h"
#import "JYWebViewController.h"
#import "Close_Db_Object.h"

#define widthSpace (10*JYScale_Width)
#define btnWidth ((JYScreenW - widthSpace * 3)/2)
#define btnHeight (btnWidth/2)
#define btnArrCount 3
#define titleHeight 50*JYScale_Height

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

#define lightTitleColor RGBA(255.0f, 255.0f, 255.0f, 0.6)

#define spaceW 20*JYScale_Width

@interface easyLoginVC ()<NSCopying,NSMutableCopying>{
    UITextField * account;
    UITextField * password;
    UIButton    * submit;
    UIButton    * getVdCode;
    UIButton    * forgetPsd;
    UILabel     * protocal;
    UIButton    * agreeP;
    
    UIView * headerView;
    UIView * contentView;
}

@end

@implementation easyLoginVC
+ (instancetype) shareAasyLoginVC{
    static easyLoginVC * onceTokenVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onceTokenVC = [[super allocWithZone:NULL] init];
    });
    return onceTokenVC;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [easyLoginVC shareAasyLoginVC];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [easyLoginVC shareAasyLoginVC];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [easyLoginVC shareAasyLoginVC];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)initView{
    [Close_Db_Object Close_SaveLoginStatus:NO];
    
    self.view.backgroundColor = tabBgColor;

    contentView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(spaceW, spaceW, JYScreenW-2*spaceW, JYScreenW-2*spaceW) andJoinView:nil];
    contentView.backgroundColor = cellBgColor;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 8;
    [self addSubview:contentView];
    
    CGRect aFrame = CGRectMake(0, spaceW, contentView.width, 40*JYScale_Height);
    UILabel * messageLabel = [JYCommonKits initLabelViewWithLabelDetail:@"账号登录" andLabelColor:kWhiteColor andLabelFont:22*JYScale_Height andLabelFrame:aFrame andJoinView:nil];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:messageLabel];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) + 28*JYScale_Height andSizeW:contentView.width - spaceW*2 andSizeH:40*JYScale_Height];
    account = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入账号" andLabelColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    [account addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    account.textAlignment = NSTextAlignmentLeft;
    account.keyboardType = UIKeyboardTypeASCIICapable;
    [contentView addSubview:account];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:0 andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:contentView.width  - spaceW*2 andSizeH:1];
    UIView * lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [contentView addSubview:lineView];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:lineView.bottom + 10*JYScale_Height andSizeW:contentView.width  - spaceW*2 andSizeH:40*JYScale_Height];
    password = [JYCommonKits initTextfieldViewWithPlaceholder:@"请输入密码" andLabelColor:RGBA(255.0f, 255.0f, 255.0f, 0.4) andLabelFont:16*JYScale_Height andFrame:aFrame andJoinView:nil];
    password.textAlignment = NSTextAlignmentLeft;
    [password addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    password.secureTextEntry = YES;
    password.keyboardType = UIKeyboardTypeASCIICapable;
    [contentView addSubview:password];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) - 2*JYScale_Height andSizeW:CGRectGetWidth(password.frame) andSizeH:1];
    lineView = [JYCommonKits getViewLineWithFrame:aFrame andJoinView:nil];
    [contentView addSubview:lineView];
    
    aFrame = WDL_CGMK(contentView.width  - spaceW - 200*JYScale_Width, lineView.bottom + 10*JYScale_Height, 200*JYScale_Width, 40*JYScale_Height);
    forgetPsd = [JYCommonKits initButtonnWithButtonTitle:@"查看协议" andLabelColor:lightTitleColor andLabelFont:14*JYScale_Height andSuperView:nil andFrame:aFrame];
    [forgetPsd addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    forgetPsd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetPsd.hidden = YES;
    [contentView addSubview:forgetPsd];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:spaceW andOriY:CGRectGetMaxY(aFrame) + 15*JYScale_Height andSizeW:contentView.width  - spaceW*2 andSizeH:44*JYScale_Height];
    submit = [JYCommonKits initButtonnWithButtonTitle:@"登录" andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andSuperView:nil andFrame:aFrame];
    [submit addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submit setBackgroundColor:RGB(184.0f, 194.0f,204.0f)];
    submit.layer.masksToBounds = YES;
    submit.layer.cornerRadius = 22;
    submit.userInteractionEnabled = NO;
    [contentView addSubview:submit];
    
    aFrame = [WDLUsefulKitModel setNewFrameWithFrame:aFrame OriX:agreeP.right andOriY:CGRectGetMaxY(aFrame)+10*JYScale_Height  andSizeW:account.width andSizeH:38*JYScale_Height];
    UIButton * userPro = [JYCommonKits initButtonnWithButtonTitle:@"还没有账号?去注册" andLabelColor:lightTitleColor andLabelFont:12*JYScale_Height andSuperView:nil andFrame:aFrame];
    [userPro addTarget:self action:@selector(regesterAction) forControlEvents:UIControlEventTouchUpInside];
    [agreeP setCenterY:userPro.centerY];
    [contentView addSubview:userPro];
    
    contentView.height = submit.bottom + spaceW*4;
    contentView.centerY = JYScreenH/2-SafeAreaTopHeight;
}
- (void)popself{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark event
- (void)forgetPasswordAction{
    
    new_ControllerWithOutPush(JYWebViewController);
    controller.isCanShare = NO;
    controller.htmlPath = @"protocal";
    [self.navigationController pushViewController:controller animated:YES];

}

- (void)submitAction{
    JYWeakify(self);
    if(![account.text isEqualToString:@""] && ![password.text isEqualToString:@""]){
        [LeanCloudInterface userLoginName:account.text password:password.text result:^(BOOL status) {
            if (status == YES) {
                [MBProgressHUD showSuccess:@"登录成功"];
                if (weakSelf.loginCom) {
                    weakSelf.loginCom(YES);
                }
            }else{
                if (weakSelf.loginCom) {
                    weakSelf.loginCom(NO);
                }
                [MBProgressHUD showError:@"登录失败"];
            }
        }];
    }else{
        [MBProgressHUD showError:@"用户名和密码都不能为空"];
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
        submit.backgroundColor = RGBA(255.0f, 0, 0,0.4);
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
