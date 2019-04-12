//
//  JYEmptyView.m
//  RTPg
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 atts. All rights reserved.
//

#import "JYEmptyView.h"
@interface JYEmptyView ()

@property (strong , nonatomic) UILabel * messageLabel;

@property (strong , nonatomic) UIImageView * emptyImg;

@end

@implementation JYEmptyView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kWhiteColor;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.messageLabel];
        [self addSubview:self.emptyImg];
    }
    return self;
}
-(void)setMessage:(NSString *)message{
    if (![message isEqualToString:@""]) {
        self.messageLabel.text = message;
        self.messageLabel.numberOfLines = 0;
        [self.messageLabel sizeToFit];
        self.messageLabel.center = CGPointMake(self.frame.size.width/2, 1);
    }
}
- (UILabel *)messageLabel{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = JY_Font_Sys_14;
        _messageLabel.textColor = JYMiddleColor;
    }
    return _messageLabel;
}
- (UIImageView *)emptyImg{
    if (!_emptyImg) {
        _emptyImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"empty_pic"]];
        _emptyImg.frame = CGRectMake(0, 0, 80*JYScale_Height, 80*JYScale_Height);
        _emptyImg.center = CGPointMake(self.frame.size.width/2, 1);
    }
    return _emptyImg;
}

- (void)layoutSubviews{
    float centerPoint = (_emptyImg.frame.size.height + _messageLabel.frame.size.height + 10*JYScale_Height)/2;
    
    CGRect tFrame = _emptyImg.frame;
    tFrame.origin.y = self.center.y - centerPoint;
    _emptyImg.frame = tFrame;
    
    tFrame = _messageLabel.frame;
    tFrame.origin.y = CGRectGetMaxY(_emptyImg.frame) + 10*JYScale_Height;
    _messageLabel.frame = tFrame;
    
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
