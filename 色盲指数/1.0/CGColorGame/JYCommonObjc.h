//
//  JYCommonObjc.h
//  CGColorGame
//
//  Created by md212 on 2019/4/18.
//  Copyright © 2019年 cyg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYCommonObjc : NSObject

//获取分数
+ (NSMutableDictionary *)getScoreInfo;
+ (NSMutableArray *)getScoreArr:(NSString *)userName;

//设置分数
+ (void)setScoreArrName:(NSString *)userName arr:(NSMutableArray *)arr;
+ (NSMutableArray *)setScoreName:(NSString *)userName score:(NSString *)score;


//超越指数
+ (NSString *)overIndex:(NSInteger)score;
//获取分数排行榜
+ (NSMutableArray *)getTopScoreArr;
+ (void)setScoreRank:(NSInteger)score;

//获取分数排行榜详细信息
+ (NSMutableArray *)getTopScoreUserArr;
+ (void)setTopArrInfo:(NSInteger)score;

//设置登录状态
+ (BOOL)getLoginStatus;
+ (void)setLoginStatus:(BOOL)status;

//设置名字
+ (NSString *)getUserName;
+ (void)setUserName:(NSString *)userName;

//获取最后一次得分
+ (NSString *)getLastScore;

//获取最高分
+ (NSString *)getBestScore;

//获取随机字符串
+ (NSString *)getRandomStr;

@end

NS_ASSUME_NONNULL_END
