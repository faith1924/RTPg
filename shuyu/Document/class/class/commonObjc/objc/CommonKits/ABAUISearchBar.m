//
//  ABAUISearchBar.m
//  ABCMobileProject
//
//  Created by mylm on 2018/11/19.
//  Copyright © 2018年 mylm. All rights reserved.
//

#import "ABAUISearchBar.h"

@implementation ABAUISearchBar
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.searchBarStyle  = UISearchBarStyleMinimal;
        self.backgroundColor = kWhiteColor;
//        self.backgroundImage = [JYCommonKits ImageWithColor:[UIColor clearColor] frame:self.frame];

        UITextField * searchField = [self valueForKey:@"_searchField"];
        if (searchField) {
            [searchField setValue:kBlackColor forKeyPath:@"_placeholderLabel.textColor"];
            [searchField setValue:JY_Font_Sys_14 forKeyPath:@"_placeholderLabel.font"];
            searchField.font = JY_Font_Sys_14;
            [searchField setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
