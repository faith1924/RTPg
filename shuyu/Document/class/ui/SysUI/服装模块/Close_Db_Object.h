//
//  Close_Db_Object.h
//  RTPg
//
//  Created by md212 on 2019/5/8.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Close_Db_Object : NSObject
+ (void)Close_SaveLoginStatus:(BOOL)Close_status;
+ (BOOL)Close_GetLoginStatus;

+ (void)Close_SaveUserInfo:(id)Close_UserInfo;
+ (id)Close_GetUserInfo;

//返回指定时间内数据
+ (NSMutableArray *)timeSortDataArr:(NSMutableArray * )arr
                          timestamp:(NSTimeInterval)disTime;
+ (void)quickSortDataArray:(NSMutableArray *)array
                startIndex:(NSInteger)startIndex
                  endIndex:(NSInteger)endIndex
                       key:(NSString *)sortKey;
+ (NSMutableArray *)getSortArr:(NSMutableArray *)array type:(NSInteger)index;

+ (NSMutableDictionary *)getSaleData:(NSMutableArray *)dataArr
                                 day:(NSInteger)day;

@end

NS_ASSUME_NONNULL_END
