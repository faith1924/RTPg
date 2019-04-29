//
//  ABALoadingAlertView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/10/31.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABALoadingAlertView.h"
@interface ABALoadingAlertView ()
@property (strong , nonatomic) UIView * bgView;
@property (strong , nonatomic) UIImageView * loadingImage;
@property (strong , nonatomic) NSMutableArray * animationImages;
@end

@implementation ABALoadingAlertView
+ (ABALoadingAlertView *)shareLoadingView{
    static ABALoadingAlertView * loadingView;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        loadingView = [[ABALoadingAlertView alloc]initWithFrame:CGRectMake(0, 0, JYScreenW, JYScreenH)];
        loadingView.backgroundColor = RGBAOF(0x000000, 0.2);
        [WDLGetKeyWindow addSubview:loadingView];
    });
    return loadingView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [JYCommonKits initializeViewLineWithFrame:CGRectMake(0, 0, 90, 90) andJoinView:self];
        _bgView.backgroundColor = RGBAOF(0x000000, 0.2);
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 12;
        _bgView.center = CGPointMake(self.width/2, self.height/2);
        
        _aotuHiddenDurning = 10;
    }
    return _bgView;
}
- (UIImageView *)loadingImage{
    if (!_loadingImage) {
        _loadingImage = [JYCommonKits initWithImageViewWithFrame:CGRectMake(5, 0, 80, 80) AndSuperView:self.bgView];
        _loadingImage.animationImages = [self animationImages]; //获取Gif图片列表
        _loadingImage.animationDuration = self.animationImages.count/5;     //执行一次完整动画所需的时长
        _loadingImage.animationRepeatCount = 0;  //动画重复次数
    }
    return _loadingImage;
}
-(void)setAotuHiddenDurning:(int )aotuHiddenDurning{
    _aotuHiddenDurning = aotuHiddenDurning;
}
-(void)setIsClickHidden:(BOOL)isClickHidden{
    _isClickHidden = isClickHidden;
    self.userInteractionEnabled = isClickHidden;
    [self addTarget:self action:@selector(hideLoading) forControlEvents:UIControlEventTouchUpInside];
}
- (NSMutableArray *)animationImages
{
    NSFileManager *fielM = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loadingGifIcon" ofType:@"bundle"];
    NSArray *arrays = [fielM contentsOfDirectoryAtPath:path error:nil];
    
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (NSString *name in arrays) {
        UIImage *image = [UIImage imageNamed:[(@"loadingGifIcon.bundle") stringByAppendingPathComponent:name]];
        if (image) {
            [imagesArr addObject:image];
        }
    }
    return imagesArr;
}
- (void)showLoading{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showLoadingView) withObject:self afterDelay:1];
}
- (void)showLoadingView{
    JYWeakify(self);
    [WDLGetKeyWindow bringSubviewToFront:self];
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 1;
    }completion:^(BOOL finished) {
        [weakSelf.loadingImage startAnimating];
    }];
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:self.aotuHiddenDurning];
}
- (void)hideLoading{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    JYWeakify(self);;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    }completion:^(BOOL finished) {
        [weakSelf.loadingImage stopAnimating];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
