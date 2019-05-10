//
//  Close_UserInfoVC.m
//  RTPg
//
//  Created by md212 on 2019/4/15.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "Close_UserInfoVC.h"
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
#define oriW 10*JYScale_Width
#define oriH 15*JYScale_Height

@interface Close_UserInfoVC ()

@end

@implementation Close_UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView{
    self.view.backgroundColor = tabBgColor;
    self.hbd_barHidden = NO;
    self.hbd_barTintColor = tabBgColor;
    self.hbd_tintColor = kWhiteColor;
    
    UIImage* itemImage= [UIImage imageNamed:@"back_btn_white"]; // Colored Image
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithImage:itemImage style:UIBarButtonItemStyleDone target:self action:@selector(popself)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    
    self.navigationItem.title = @"个人账户";
    self.hbd_titleTextAttributes = @{
                                     NSFontAttributeName:JY_Font_Sys(18*JYScale_Height), NSForegroundColorAttributeName:[UIColor whiteColor]
                                     };
    NSMutableDictionary * userInfo = [Close_Db_Object Close_GetUserInfo];
    
    NSArray * imageArr = @[@"icon-40",@"icon-40"];
    NSArray * titleArr = @[userInfo[@"account"],userInfo[@"company"]];

    float kitHeight = 45*JYScale_Height;
    
    for (int i = 0; i < imageArr.count; i++) {
       [self creatKitView:CGRectMake(oriW, (oriH + kitHeight) * i, JYScreenW - oriW * 2, kitHeight) title:titleArr[i] res:imageArr[i] supView:self.contentView];
    }
 
}
- (UIControl * )creatKitView:(CGRect)aFrame title:(NSString *)title res:(NSString *)path supView:(UIView * )supView{
    UIControl * control = [JYCommonKits initControlWithFrame:aFrame andJoinView:supView];
    control.backgroundColor = cellBgColor;
    control.layer.masksToBounds = YES;
    control.layer.cornerRadius = 8;
    
    UIImageView * imageV = [JYCommonKits initWithImageViewWithFrame:CGRectMake(oriW*2 , 0, 14*JYScale_Height, 14*JYScale_Height) AndSuperView:control];
    imageV.centerY = control.height/2;
    imageV.image = [UIImage imageNamed:path];
    
    UILabel * label = [JYCommonKits initLabelViewWithLabelDetail:title andTextAlignment:0 andLabelColor:lightTitleColor andLabelFont:14*JYScale_Height andLabelFrame:CGRectMake(imageV.right + oriW * 2, 0, supView.width - imageV.left, aFrame.size.height) andJoinView:control];
    label.centerY = control.height/2;
    
    return control;
}

- (void)popself{
    [self.navigationController popViewControllerAnimated:YES];
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
