//
//  JYTabBarController.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYTabBarController.h"
#import "newsVC.h"
#import "videoVC.h"
#import "infoVC.h"
#import "episodeVC.h"
#import "JYNavigationController.h"

#define kClassKey   @"rootVCClassString"
#define kTitleKey   @"title"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface JYTabBarController ()<UITabBarControllerDelegate>

@end

@implementation JYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果中间有按钮
    if (_type == defaultValue1) {
        _JYBar = [[JYTabBar alloc] init];
    
        [_JYBar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setValue:_JYBar forKeyPath:@"tabBar"];
        
        self.delegate = self;
    }
    
    self.delegate = self;
    NSArray *childItemsArray = @[
                                 @{kClassKey  : @"episodeVC",
                                   kTitleKey  : @"段子",
                                   kImgKey    : @"icon_subscription",
                                   kSelImgKey : @"icon_subscription_pre"},
                                 
                                 @{kClassKey  : @"newsVC",
                                   kTitleKey  : @"资讯",
                                   kImgKey    : @"icon_zl",
                                   kSelImgKey : @"icon_zl_pre"},
                                 
                                 @{kClassKey  : @"videoVC",
                                   kTitleKey  : @"视频",
                                   kImgKey    : @"icon_quotation",
                                   kSelImgKey : @"icon_quotation_pre"},
                                 
                                 @{kClassKey  : @"infoVC",
                                   kTitleKey  : @"我的",
                                   kImgKey    : @"icon_mine",
                                   kSelImgKey : @"icon_mine_pre"} ];
    
    [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
        JYNavigationController *nav = [[JYNavigationController alloc] initWithRootViewController:vc];
        vc.title = dict[kTitleKey];

        UIImage * musicImage = [UIImage imageNamed:dict[kImgKey]];
        UIImage * musicImageSel = [UIImage imageNamed:dict[kSelImgKey]];
        musicImage = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        musicImageSel = [musicImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:dict[kTitleKey] image:musicImage selectedImage:musicImageSel];
        nav.tabBarItem = item;
  
        [self addChildViewController:nav];
    }];
    
    //去除ios12底部跳动
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    // Do any additional setup after loading the view from its nib.
}
// 重写选中事件， 处理中间按钮选中问题
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    _JYBar.centerBtn.selected = (tabBarController.selectedIndex == self.viewControllers.count/2);
    
    if (self.JYDelegate){
        [self.JYDelegate JYTabBarController:tabBarController didSelectViewController:viewController];
    }
}

- (void)buttonAction:(UIButton *)button{
    NSInteger count = self.viewControllers.count;
    self.selectedIndex = count/2;//关联中间按钮
    [self tabBarController:self didSelectViewController:self.viewControllers[self.selectedIndex]];
}
- (instancetype)initWithTabbarType:(JYtabBarControlType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
