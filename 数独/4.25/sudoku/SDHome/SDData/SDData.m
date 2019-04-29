//
//  SDData.m
//  sudoku
//
//  Created by md212 on 2019/4/24.
//  Copyright © 2019年 com/qianfeng/mac. All rights reserved.
//

#import "SDData.h"

#define UserDefault [NSUserDefaults standardUserDefaults]

@implementation SDData
+ (NSString *)getLastScore{
    return [self getMMSSFromSS:[UserDefault objectForKey:@"lastScore"]];
}
+ (NSString *)getBestScore{
     return [self getMMSSFromSS:[UserDefault objectForKey:@"bestScore"]];
}
+ (void)setLastScore:(NSTimeInterval )score{
    [UserDefault setObject:@(score) forKey:@"lastScore"];
}
+ (void)setBestScore:(NSTimeInterval)score{
    NSInteger oldScore = [[UserDefault objectForKey:@"bestScore"] doubleValue];
    if (oldScore > score) {
        [UserDefault setObject:@(score) forKey:@"bestScore"];
    }
}
+ (void)setLevel:(int)level{
    [[NSUserDefaults standardUserDefaults] setObject:@(level) forKey:@"level"];
}
+ (int)getLevel{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] intValue];
}

//时间戳转时间
+ (NSString *)getTimeFromInteger:(NSTimeInterval)totalTime{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:totalTime];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:MM:SS"];
    return [formatter stringFromDate:date];
}

//时间转时间戳
+ (NSTimeInterval)GetIntervalFromDate:(NSString *)dateStr{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:MM:SS"];
    NSDate * date = [formatter dateFromString:dateStr];
    return [date timeIntervalSince1970];
}

//传入 秒  得到 xx:xx:xx
+ (NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger totle = [totalTime integerValue];
    NSInteger hour = totle/3600;
    NSInteger minute = (totle%3600)/60;
    NSInteger second = (totle%3600)%60;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",minute];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",second];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
    
}
+ (NSString *)getTimeInter:(NSInteger)time{
    NSInteger totle = time;
    NSInteger hour = totle/3600;
    NSInteger minute = (totle%3600)/60;
    NSInteger second = (totle%3600)%60;
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",hour];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",minute];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",second];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}
@end
