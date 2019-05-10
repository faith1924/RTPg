//
//  comHeadView.m
//  RTPg
//
//  Created by md212 on 2019/5/9.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "comHeadView.h"

#define viewHeight 50*JYScale_Height
#define oriW 10*JYScale_Height
#define tabBgColor RGBA(31.0f, 40.0f, 58.0f, 1)
#define cellBgColor RGBA(42.0f, 58.0f, 82.0f, 1);

@implementation comHeadView
- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr iconArr:(NSArray *)iconArr{
    _titleArr = titleArr;
    _iconArr = iconArr;
    
    frame.size.width = JYScreenW - oriW * 2;
    frame.size.height = viewHeight;
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = cellBgColor;
        
        UIControl * control = nil;
        UILabel * label = nil;
        UIImageView * image = nil;
        CGSize size;
        float labOri = 0;
        float labH = 16*JYScale_Height;

        NSInteger count = _titleArr.count>_iconArr.count?_iconArr.count:_titleArr.count;
        float conW = frame.size.width/count;
        for (int i = 0; i < (_titleArr.count>_iconArr.count?_iconArr.count:_titleArr.count); i++) {
            control = [JYCommonKits initControlWithFrame:CGRectMake(conW * i, 0, conW, self.height) andJoinView:self];
            [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchDown];

            size = [_titleArr[i] sizeWithAttributes:@{NSFontAttributeName:JY_Font_Sys(labH)}];
            
            image = [JYCommonKits initWithImageViewWithFrame:CGRectMake(0, 0, labH, labH) AndSuperView:control AndImage:[UIImage imageNamed:iconArr[i]]];
            label = [JYCommonKits initLabelViewWithLabelDetail:_titleArr[i] andTextAlignment:0 andLabelColor:kWhiteColor andLabelFont:labH andLabelFrame:CGRectMake(0, 0, size.width, control.height) andJoinView:control];

            labOri = (control.width - (image.width + size.width + oriW))/2;
            image.left = labOri;
            label.left = image.right + oriW;

            image.centerY = control.height/2;
            label.centerY = image.centerY;
        }
    }
    return self;
}
- (void)setIconArr:(NSMutableArray *)iconArr{
    if (iconArr.count == 0 || iconArr == nil) {
        return;
    }
    _iconArr = iconArr;
}
-(void)setTitleArr:(NSMutableArray *)titleArr{
    
}
- (void)controlAction:(UIControl *)control{
    
}
//
//@property (strong , nonatomic) NSMutableArray * titleArr;
//
//@property (strong , nonatomic) NSMutableArray * iconArr;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
