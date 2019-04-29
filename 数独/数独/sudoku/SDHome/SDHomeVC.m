//
//  SDHomeVC.m
//  sudoku
//
//  Created by md212 on 2019/4/24.
//  Copyright © 2019年 com/qianfeng/mac. All rights reserved.
//

#import "SDHomeVC.h"
#import "SDData.h"
#import "SDNumberBVC.h"

@interface SDHomeVC ()

@end

@implementation SDHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confInit) name:@"reloadScore" object:nil];
    [self confInit];
    // Do any additional setup after loading the view from its nib.
}
- (void)confInit{
    self.lastScore.text = [NSString stringWithFormat:@"上一次成绩：%@",[SDData getLastScore]];
    self.bestScore.text = [NSString stringWithFormat:@"最好成绩：%@",[SDData getBestScore]];
}
- (IBAction)easyAction:(UIButton *)sender {
    [SDData setLevel:0];
    if (self.ClickIndex) {
        self.ClickIndex(easyLev);
    }
    [self popVC];
}
- (IBAction)middleAction:(UIButton *)sender {
    [SDData setLevel:1];
    if (self.ClickIndex) {
        self.ClickIndex(midLev);
    }
    [self popVC];
}
- (IBAction)hardAction:(UIButton *)sender {
    [SDData setLevel:2];
    if (self.ClickIndex) {
        self.ClickIndex(hardLev);
    }
    [self popVC];
}

- (void)popVC{
    SDNumberBVC * sdvc = [[SDNumberBVC alloc]init];
    sdvc.level = [SDData getLevel];
    [self presentViewController:sdvc animated:YES completion:nil];
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
