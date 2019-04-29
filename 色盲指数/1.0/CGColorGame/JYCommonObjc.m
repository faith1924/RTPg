//
//  JYCommonObjc.m
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import "JYCommonObjc.h"

@implementation JYCommonObjc
+ (NSMutableDictionary *)getScoreInfo{
    NSMutableDictionary * info = nil;
    NSMutableDictionary * dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"scoreInfo"];
    if (dic == nil || dic == NULL) {
        info = [NSMutableDictionary new];
    }else{
        info = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:@"scoreInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return info;
}
+ (void)setScoreArrName:(NSString *)userName arr:(NSMutableArray *)arr{
    if ([userName isEqualToString:@""] || userName == nil) {
        return ;
    }
    NSMutableDictionary * dic = [self getScoreInfo];
    [dic setObject:arr forKey:userName];
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"scoreInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSMutableArray *)setScoreName:(NSString *)userName score:(NSString *)score{
    if ([userName isEqualToString:@""] || userName == nil) {
        return [NSMutableArray new];
    }
    NSMutableArray * arr = [self getScoreArr:userName];

    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:score forKey:@"score"];
    [dic setObject:[self getDateStr] forKey:@"time"];
    [arr addObject:dic];
    
    [self setScoreArrName:userName arr:arr];
    return arr;
}
+ (NSString *)getDateStr{
    NSDate * date = [NSDate new];
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd - HH:mm:ss"];
    NSString * dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+ (NSMutableArray *)getScoreArr:(NSString *)userName{
    if ([userName isEqualToString:@""] || userName == nil) {
        return [NSMutableArray new];
    }
    NSMutableArray * arr = [[self getScoreInfo] objectForKey:userName];
    if (arr == nil || arr == NULL) {
        arr = [NSMutableArray new];
    }else{
        arr = arr.mutableCopy;
    }
    return arr;
}

//超越指数
+ (NSString *)overIndex:(NSInteger)score{
    NSMutableArray * arr = [self getTopScoreArr];
    NSInteger index = [arr indexOfObject:@(score)];
    NSString * remark = @"";
    float percent = 100;
    if (arr.count > 1) {
        percent = index * 100/(arr.count-1);
    }
    if (percent <= 20) {
        remark = @"快去预约眼科医生吧";
    }else if (percent <= 40){
        remark = @"医生建议：少用眼，多运动";
    }else if (percent <= 60){
        remark = @"温馨提示：平时要注意用眼时长";
    }else if (percent <= 80){
        remark = @"视力良好,继续保持";
    }else if (percent <= 100){
        remark = @"你一定是千里眼转世";
    }
    return [NSString stringWithFormat:@"恭喜你打败了%.02f％的玩家,%@",percent,remark];
}

//获取分数排行榜
+ (NSMutableArray *)getTopScoreArr{
    NSMutableArray * scoreArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"scoreRank"];
    NSMutableArray * rankArr = nil;
    if (scoreArr == nil || scoreArr == NULL) {
        rankArr = [NSMutableArray new];
    }else{
        rankArr = [NSMutableArray arrayWithArray:scoreArr];
    }
    return rankArr;
}

+ (void)setScoreRank:(NSInteger)score{
    NSMutableArray * arr = [self getTopScoreArr];
    [arr addObject:@(score)];
    NSArray * rankArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    [[NSUserDefaults standardUserDefaults] setObject:rankArr forKey:@"scoreRank"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取分数排行榜详细信息
+ (NSMutableArray *)getTopScoreUserArr{
    NSMutableArray * arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"scoreRankInfo"];
    NSMutableArray * topRankArr = nil;
    if (arr == nil || arr == NULL) {
        topRankArr = [NSMutableArray new];
    }else{
        topRankArr = [NSMutableArray arrayWithArray:arr];
    }
    return topRankArr;
}
+ (void)setTopArrInfo:(NSInteger)score{
    NSMutableArray * rankArrInfo = [self getTopScoreUserArr];
    NSInteger minScore = 0;
    NSInteger maxScore = 0;
    if (rankArrInfo.count > 0) {
        for (NSInteger x = 0; x <= rankArrInfo.count-1; x--) {
            maxScore = [[rankArrInfo[x] objectForKey:@"score"] integerValue];
            
            if (x + 1 <= rankArrInfo.count - 1) {
                minScore = [[rankArrInfo[x+1] objectForKey:@"score"] integerValue];
            }
            
            if (score >= maxScore) {
                [rankArrInfo insertObject:@{@"score":@(score),@"userName":[self getUserName],@"time":[self getDateStr]} atIndex:x];
                break;
            }else{
                if (score >= minScore) {
                    [rankArrInfo insertObject:@{@"score":@(score),@"userName":[self getUserName],@"time":[self getDateStr]} atIndex:x+1];
                    break;
                }else{
                    if(x == rankArrInfo.count - 1){
                        [rankArrInfo addObject:@{@"score":@(score),@"userName":[self getUserName],@"time":[self getDateStr]}];
                        break;
                    }
                    continue;
                }
            }
        }
    }else{
        [rankArrInfo addObject:@{@"score":@(score),@"userName":[self getUserName],@"time":[self getDateStr]}];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[rankArrInfo subarrayWithRange:NSMakeRange(0, rankArrInfo.count < 10?rankArrInfo.count:10)] forKey:@"scoreRankInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//设置登录状态
+ (BOOL)getLoginStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"loginStatus"];
}
+ (void)setLoginStatus:(BOOL)status{
    [[NSUserDefaults standardUserDefaults] setBool:status forKey:@"loginStatus"];
}
//设置名字
+ (NSString *)getUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
}
+ (void)setUserName:(NSString *)userName{
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"userName"];
}
//获取最后一次得分
+ (NSString *)getLastScore{
    NSMutableArray * arr = [self getScoreArr:[self getUserName]];
    if (arr.count > 1) {
        return arr[arr.count-1][@"score"];
    }else{
        return @"0";
    }
}
//获取最高分
+ (NSString *)getBestScore{
    NSMutableArray * arr = [self getScoreArr:[self getUserName]];
    
    __block NSInteger bestScore = 0;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"score"] integerValue] > bestScore) {
            bestScore = [obj[@"score"] integerValue];
        }
    }];
    if (arr.count > 1) {
        return [NSString stringWithFormat:@"%ld",bestScore];
    }else{
        return @"0";
    }
}

//获取随机字符串
+ (NSString *)getRandomStr
{
    static int kNumber = 5;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRST";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
