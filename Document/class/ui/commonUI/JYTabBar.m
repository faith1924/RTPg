//
//  JYTabBar.m
//  RTPg
//
//  Created by 汪栋梁 on 2019/4/2.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "JYTabBar.h"

@implementation JYTabBar
- (instancetype)init{
    if (self = [super init]){
        [self initView];
    }
    return self;
}

- (void)initView{
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _defaultImageView = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, 0, 53, 53) AndSuperView:self];
    
    //去除选择时高亮
    _centerBtn.adjustsImageWhenHighlighted = NO;
    [self addSubview:_centerBtn];
}

// 设置layout
- (void)layoutSubviews {
    [super layoutSubviews];
    switch (self.position) {
        case JYTabBarCenterButtonDefault:
            _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _centerWidth)/2.0, (SafeTabbarBottomHeight - _centerHeight)/2.0 + self.centerOffsetY, _centerWidth, _centerHeight);
            break;
        case JYTabBarCenterButtonHalf:
            _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _centerWidth)/2.0, -_centerHeight/2.0 + self.centerOffsetY, _centerWidth, _centerHeight);
            break;
        case JYTabBarCenterButtonLittle:
            _centerBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _centerWidth)/2.0, -_centerHeight/5.0 + self.centerOffsetY, _centerWidth, _centerHeight);
            break;
        default:
            break;
    }
    
}

- (void)setCenterImage:(UIImage *)centerImage {
    _centerImage = centerImage;
    // 如果设置了宽高则使用设置的大小
    if (self.centerWidth <= 0 && self.centerHeight <= 0){
        //根据图片调整button的位置(默认居中，如果图片中心在tabbar的中间最上部，这个时候由于按钮是有一部分超出tabbar的，所以点击无效，要进行处理)
        _centerWidth = centerImage.size.width;
        _centerHeight = centerImage.size.height;
    }
    [_defaultImageView setImage:centerImage];
    _defaultImageView.center = _centerBtn.center;
    //    [_centerBtn setImage:centerImage forState:UIControlStateNormal];
}
- (void)setDefaultImageView:(UIImageView *)defaultImageView{
    if (defaultImageView) {
        _defaultImageView = defaultImageView;
        _defaultImageView.center = _centerBtn.center;
    }
}
-(void)setCenterDefaultImage:(UIImage *)centerDefaultImage{
    if (centerDefaultImage) {
        _centerDefaultImage = centerDefaultImage;
        [_defaultImageView setImage:centerDefaultImage];
    }
}
- (void)setCenterSelectedImage:(UIImage *)centerSelectedImage {
    _centerSelectedImage = centerSelectedImage;
    //    [_centerBtn setImage:centerSelectedImage forState:UIControlStateSelected];
}

//处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.hidden){
        return [super hitTest:point withEvent:event];
    }else {
        //转换坐标
        CGPoint tempPoint = [self.centerBtn convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerBtn.bounds, tempPoint)){
            //返回按钮
            return _centerBtn;
        }else {
            return [super hitTest:point withEvent:event];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
