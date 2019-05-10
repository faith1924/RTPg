//
//  userCenterVC.m
//  RTPg
//
//  Created by md212 on 2019/5/8.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "userCenterVC.h"
#import "Close_UserInfoVC.h"
#import "LeanCloudInterface.h"
#import "Close_Db_Object.h"
#import "JYWebViewController.h"
#import "easyLoginVC.h"

@interface userCenterVC (){
    NSArray * titleArr;
    NSArray * iconArr;
}

@property (strong , nonatomic) UIView *headerView;

@property (strong , nonatomic) UILabel * headerLabel;

@end

#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

#define oriWidth 10*JYScale_Width
#define widthSpace (10*JYScale_Width)
#define btnWidth ((JYScreenW - widthSpace * 3)/2)
#define btnHeight (btnWidth/2)
#define btnArrCount 3
#define titleHeight 50*JYScale_Height

#define imageH 40*JYScale_Width
#define labH 12*JYScale_Width


@implementation userCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    // Do any additional setup after loading the view.
}
- (void)dataInit{
    self.contentView.backgroundColor = tabBgColor;
    self.hbd_barHidden = YES;
    [self.contentView addSubview:self.headerView];
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, JYStatusBarHeight, JYScreenW, titleHeight) andJoinView:nil];
        _headerLabel = [JYCommonKits initLabelViewWithLabelDetail:@"平台数据" andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:16*JYScale_Height andLabelFrame:CGRectMake(widthSpace, 0, _headerView.width - widthSpace, titleHeight) andJoinView:_headerView];
        
        UIControl * control = nil;
        titleArr = @[@"个人账户",@"联系客服",@"关于我们",@"用户协议"];
        iconArr = @[@"icon-40",@"icon-40",@"icon-40",@"icon-40"];
        for (int i = 0; i < titleArr.count; i++) {
           
           control = [self creatControlTitle:titleArr[i]
                                    iconPath:iconArr[i]
                                       frame:CGRectMake((btnWidth+oriWidth)*(i%2)+oriWidth,_headerLabel.bottom + i/2 * (oriWidth + btnHeight), btnWidth, btnHeight)
                                   superView:_headerView
                                      conTag:200 + i];
        }
        
        
        UIButton * logout = [JYCommonKits initButtonnWithButtonTitle:@"退出登录" andLabelColor:RGBA(255.0f, 255.0f, 255.0f, 0.6) andLabelFont:labH+4*JYScale_Height andSuperView:_headerView andFrame:CGRectMake(0, control.bottom + 40*JYScale_Height, 300*JYScale_Width, 45*JYScale_Height)];
        logout.layer.masksToBounds = YES;
        logout.layer.cornerRadius = 16;
        logout.centerX = _headerView.width/2;
        [logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchDown];
        logout.backgroundColor = cellBgColor;
        
        _headerView.height = logout.bottom + oriWidth * 2;
    }
    return _headerView;
}


- (UIControl *)creatControlTitle:(NSString *)title iconPath:(NSString *)path frame:(CGRect)tFrame superView:(UIView *)supView conTag:(NSInteger)tag{
    UIControl * control = [JYCommonKits initControlWithFrame:tFrame andJoinView:supView];
    control.backgroundColor = cellBgColor;
    control.tag = tag;
    control.layer.masksToBounds = YES;
    control.layer.cornerRadius = 8;
    [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchDown];
    

    float oriMid = (tFrame.size.height - imageH - oriWidth - labH)/2;
    UIImageView * imageView = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, oriMid, imageH, imageH) AndSuperView:control];
    imageView.centerX = tFrame.size.width/2;
    imageView.image = [UIImage imageNamed:path];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.height/2;
    
    [JYCommonKits initLabelViewWithLabelDetail:title andLabelColor:RGBA(255.0f, 255.0f, 255.0f, 0.6) andLabelFont:labH andLabelFrame:CGRectMake(0, imageView.bottom+oriWidth, control.width, labH) andJoinView:control];

    return control;
}
- (void)controlAction:(UIControl *)control{
    JYWeakify(self);
    if (control.tag == 200) {
        [LeanCloudInterface getClassInfo:@"appUserInfo" keyDic:@[@"account",@"company"] result:^(BOOL status,id object) {
            NSDictionary * dic = object[0];
            if (dic != nil) {
                [Close_Db_Object Close_SaveUserInfo:dic];
                Close_UserInfoVC * infoVC = [[Close_UserInfoVC alloc]init];
                [weakSelf.navigationController pushViewController:infoVC animated:YES];
            }
        }];
     
    }else if (control.tag == 201){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"02122506688"] options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    }else if (control.tag == 202){
        new_ControllerWithOutPush(JYWebViewController);
        controller.isCanShare = NO;
        controller.htmlPath = @"about";
        [self.navigationController pushViewController:controller animated:YES];
    }else if (control.tag == 203){
        new_ControllerWithOutPush(JYWebViewController);
        controller.isCanShare = NO;
        controller.htmlPath = @"protocal";
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)logoutAction{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"确定退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        easyLoginVC * logVC = [easyLoginVC shareAasyLoginVC];
        UINavigationController * nv = [[UINavigationController alloc]initWithRootViewController:logVC];
        WDLGetKeyWindow.rootViewController = nv;
        logVC.loginCom = ^(BOOL status) {
            if (status == YES) {
                [Close_Db_Object Close_SaveLoginStatus:YES];
                
                JYTabBarController * rootVC = [[JYTabBarController alloc]initWithTabbarType:defaultModel];
                WDLGetKeyWindow.rootViewController  = rootVC;
            }
        };
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
