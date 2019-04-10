//
//  ABACellImageView.m
//  ABCMobileProject
//
//  Created by mmy on 2018/9/6.
//  Copyright © 2018年 mmy. All rights reserved.
//

#import "ABACellImageView.h"
#import "ABASharePopView.h"

#define margin 10*JYScale_Width
#define imageSpace 13*JYScale_Width
#define btnTag 14300

@interface ABACellImageView ()
@property (strong , nonatomic) NSMutableDictionary * imageDic;
@property (strong , nonatomic) NSMutableArray * imageUrl;
@end

@implementation ABACellImageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.height = 0;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (NSMutableDictionary *)imageDic{
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary new];
    }
    return _imageDic;
}
- (NSMutableArray *)imageUrl{
    if (!_imageUrl) {
        _imageUrl = [NSMutableArray new];
    }
    return _imageUrl;
}
- (void)setImageUrlArr:(NSMutableArray *)imageUrlArr{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.imageDic removeAllObjects];
    [self.imageUrl removeAllObjects];
    
    NSInteger count = MIN(imageUrlArr.count, 3);
    
    float oriW = 0;
    float oriH = 0;
    
    switch (count) {
        case 0:
            self.height = 0;
            break;
        case 1:
            oriW = CGRectGetWidth(self.frame) - margin * 2;
            oriH = (CGRectGetWidth(self.frame) - margin * 2)/2;
            break;
        case 2:
            oriW = (CGRectGetWidth(self.frame) - margin * 2 - imageSpace)/2;
            oriH = (CGRectGetWidth(self.frame) - margin * 2)/2;
            break;
        case 3:
            oriW = (CGRectGetWidth(self.frame) - margin * 2 - imageSpace * 2)/3;
            oriH = oriW;
            break;
            
        default:
            break;
    }
    UIButton * imageView = nil;
    JYWeakify(self);
    CGRect tFrame = CGRectZero;
    for (int x = 0; x < count; x++) {
        tFrame = CGRectMake(margin + (imageSpace + oriW) * x, margin, oriW, oriH);
        
        imageView = [JYCommonKits initButtonnWithButtonTitle:@"" andLabelColor:nil andLabelFont:0 andSuperView:self andFrame:tFrame];
        imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        NSURL * url = [NSURL URLWithString:WDLTurnIdToString(imageUrlArr[x])];
        [imageView addTarget:self action:@selector(scaleImageOperation:) forControlEvents:UIControlEventTouchUpInside];
        [_imageUrl addObject:url];
        imageView.tag  = btnTag + x;
        
        [imageView sd_setImageWithURL:url forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                //图片处理
                [imageView setImage:image forState:UIControlStateNormal];
                [weakSelf.imageDic setObject:image forKey:@(x)];
            }else{
                NSLog(@"图片为空%@",url);
                [imageView setImage:defaultImage forState:UIControlStateNormal];
                [weakSelf.imageDic setObject:defaultImage forKey:@(x)];
            }
        }];
    }
    self.height = imageView.bottom;
}
- (void)scaleImageOperation:(UIButton *)sender{
    int index = (int)sender.tag - btnTag;
    [[ABASharePopView sharePopView] shareImageWithImageDic:_imageDic withImagesUrlArr:_imageUrl withIndex:index];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
