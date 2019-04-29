//
//  JYSingleVC.m
//  RTPg
//
//  Created by md212 on 2019/4/15.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "JYSingleVC.h"

@interface JYSingleVC ()<NSCopying,NSMutableCopying>

@end

@implementation JYSingleVC
+ (instancetype) shareLoginVC{
    static JYSingleVC * onceTokenVC = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        onceTokenVC = [[super allocWithZone:NULL] init];
    });
    return onceTokenVC;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [JYSingleVC shareLoginVC];
}
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [JYSingleVC shareLoginVC];
}
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [JYSingleVC shareLoginVC];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
