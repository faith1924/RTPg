//
//  SDData.h
//  sudoku
//
//  Created by md212 on 2019/4/24.
//  Copyright © 2019年 com/qianfeng/mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDData : NSObject
+ (NSString *)getLastScore;
+ (NSString *)getBestScore;
+ (void)setLastScore:(NSTimeInterval)score;
+ (void)setBestScore:(NSTimeInterval)score;
+ (int)setLevel:(int)level;
+ (int)getLevel;
//时间戳转时间
+ (NSString *)getTimeFromInteger:(NSTimeInterval)totalTime;

//时间转时间戳
+ (NSTimeInterval)GetIntervalFromDate:(NSString *)dateStr;

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

+ (NSString *)getTimeInter:(NSInteger)time;
@end

NS_ASSUME_NONNULL_END
