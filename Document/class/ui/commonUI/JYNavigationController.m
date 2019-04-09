//
//  JYNavigationController.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
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
    [self setNavigationBarAppearance];
    // Do any additional setup after loading the view.
}
- (void)setNavigationBarAppearance
{
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = item_Color;     // 设置item颜色
    textAttrs[NSFontAttributeName] = item_Font;  // 统一设置item字体大小
    [UINavigationBar appearance].titleTextAttributes=textAttrs;
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
