//
//  JYNavigationController.m
//  RTPg
//
//  Created by atts on 2019/4/2.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYNavigationController.h"

//默认颜色
#define bg_Color [UIColor whiteColor]
#define item_Color [UIColor blackColor]
#define item_Font [UIFont systemFontOfSize:16]

@interface JYNavigationController ()

@end

@implementation JYNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    if ( self = [super initWithRootViewController:rootViewController]) {
        self.view.backgroundColor = bg_Color;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.enabled = YES;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(popself)];
    
    [self setNavigationBarAppearance];
    // Do any additional setup after loading the view.
}

/**
 *  返回手势代理
 *
 *  @param gestureRecognizer gestureRecognizer
 *
 *  @return BOOL
 */
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer{
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)setNavigationBarAppearance
{
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = item_Color;     // 设置item颜色
    textAttrs[NSFontAttributeName] = item_Font;  // 统一设置item字体大小
    [UINavigationBar appearance].titleTextAttributes=textAttrs;
}

#pragma mark - 重载父类进行改写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //先进入子Controller
    [super pushViewController:viewController animated:animated];
    //替换掉leftBarButtonItem
    if ([self.viewControllers count] > 1) {
        viewController.navigationItem.leftBarButtonItem =[self customLeftBackButton];
    }
}
#pragma mark - 自定义返回按钮图片
-(UIBarButtonItem*)customLeftBackButton{
    UIImage* itemImage= [UIImage imageNamed:@"back_btn_white"]; // Colored Image
    itemImage = [itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithImage:itemImage style:UIBarButtonItemStyleDone target:self action:@selector(popself)];
    self.navigationItem.leftBarButtonItem=leftBtn;
    return leftBtn;
}

#pragma mark - 返回按钮事件(pop)
-(void)popself
{
    UIViewController *view = self.topViewController;
    [view.view endEditing:YES];
    [self popViewControllerAnimated:YES];
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
