//
//  ViewController.m
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import "ViewController.h"
#import "CGShowVC.h"
#import "JYCommonObjc.h"
#import "CGScoreTB.h"
#import "LeanCloudInterface.h"
#import "MBProgressHUD+JJ.h"
#import "CGUserInfoConf.h"

#define resEmail @"1924Faith@gamil.com"

@interface ViewController ()<UITextFieldDelegate>
{
    NSString * _message ;
}
@property (strong , nonatomic) UITextField * userTF;

@property (strong , nonatomic) NSString * userName;

@property (assign , nonatomic) BOOL loginStatus;

@property (assign) CGgameLevel level;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tabView];
    
    //更新成绩
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:@"notificationUpdataID" object:nil];
    
    //获取登录状态-有设置名字 代表已经登录，设置名字之后会缓存到本地
    _loginStatus = [JYCommonObjc getLoginStatus];
    if (!_loginStatus) {
        _message = @"取个拉风的昵称吧";
    }else{
        self.userName = [JYCommonObjc getUserName];
    }
    
    //设置最好成绩 最后的成绩
    [self updateUI];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)tabView{
    UIImage * leftImage = [UIImage imageNamed:@"icon_mz"];
    leftImage = [leftImage imageWithRenderingMode:UIImageRenderingModeAutomatic];

    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"rename" style:UIBarButtonItemStylePlain target:self action:@selector(addAccount)];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    
    UIImage * rightImage = [UIImage imageNamed:@"subscription_article_detail_more"];
    rightImage = [rightImage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    
    UIBarButtonItem * rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"more" style:UIBarButtonItemStylePlain target:self action:@selector(shareList)];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

//跳转到成绩排行
- (void)shareList{
    if([[JYCommonObjc getScoreArr:[JYCommonObjc getUserName]] count] == 0){
        [MBProgressHUD showMessage:@"没有任何成绩～"];
        return;
    }
    CGScoreTB * vc = [CGScoreTB new];
    [self.navigationController pushViewController:vc animated:YES];
}

//设置昵称的弹窗
- (void)addAccount{
    __block __weak typeof(self) weakSelf = self;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"昵称" message:_message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.delegate = self;
        textField.placeholder = @"输入昵称";
        weakSelf.userTF =  textField;
    }];
    
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * submit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([weakSelf.userTF.text isEqualToString:@""]){
            weakSelf.userName = [JYCommonObjc getRandomStr];
        }
        //保存昵称
        weakSelf.userName = weakSelf.userTF.text;
        
        if (weakSelf.loginStatus == NO) {
            [weakSelf popGame];
        }
        
        weakSelf.loginStatus = YES;
        [JYCommonObjc setLoginStatus:YES];
        [JYCommonObjc setUserName:weakSelf.userName];
        [LeanCloudInterface userRegesterName:weakSelf.userName password:weakSelf.userName email:resEmail result:^(BOOL status) {
            if (status == YES) {
                NSLog(@"successs");
            }else{
                NSLog(@"fail");
            }
        }];
    }];
    
    if(_loginStatus == YES){
        [alertController addAction:cancell];
        weakSelf.userTF.text = weakSelf.userName;
    }
    [alertController addAction:submit];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)updateUI{
    self.lastScore.text = [NSString stringWithFormat:@"上一次用时：%@",[JYCommonObjc getLastScore]];
    self.bestScore.text = [NSString stringWithFormat:@"最短用时：%@",[JYCommonObjc getBestScore]];
}
//难度选择
- (IBAction)smallFishAction:(UIButton *)sender {
    _level = CGgameLevelEase;
    if (_loginStatus == NO) {
        [self addAccount];
        return;
    }
    [self popGame];
}
- (IBAction)oldFishAction:(UIButton *)sender {
    _level = CGgameLevelNormal;
    if (_loginStatus == NO) {
        [self addAccount];
        return;
    }
    [self popGame];
}
- (IBAction)legendPlayerAction:(UIButton *)sender {
    _level = CGgameLevelHard;
    if (_loginStatus == NO) {
        [self addAccount];
        return;
    }
    [self popGame];
}
- (void)popGame{
    CGShowVC *showVC = [[CGShowVC alloc] init];
    showVC.level = _level;
    [self.navigationController pushViewController:showVC animated:YES];
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
