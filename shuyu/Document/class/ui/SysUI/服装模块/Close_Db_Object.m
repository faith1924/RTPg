//
//  Close_Db_Object.m
//  RTPg
//
//  Created by md212 on 2019/5/8.
//  Copyright © 2019年 汪栋梁. All rights reserved.
//

#import "Close_Db_Object.h"

#define userLoginStatus  @"Close_ID"
#define userInfo  @"Close_UserInfo"

@implementation Close_Db_Object
+ (void)Close_SaveLoginStatus:(BOOL)Close_status{
    [JYGetUserDefault setBool:Close_status forKey:userLoginStatus];
    [JYGetUserDefault synchronize];
}
+ (BOOL )Close_GetLoginStatus{
   return [JYGetUserDefault boolForKey:userLoginStatus];
}
+ (void)Close_SaveUserInfo:(id)Close_UserInfo{
    [JYGetUserDefault setObject:Close_UserInfo forKey:userInfo];
    [JYGetUserDefault synchronize];
}
+ (id)Close_GetUserInfo{
    return [JYGetUserDefault objectForKey:userInfo];
}

//返回指定时间内数据
+ (NSMutableArray *)timeSortDataArr:(NSMutableArray * )arr timestamp:(NSTimeInterval)disTime{
    NSDate * date = [NSDate new];
    NSTimeInterval now = [date timeIntervalSince1970];
    
    //如果时间大于现在就返回
    if (now < disTime || disTime == 0) {
        return arr;
    }
    
    
    NSMutableArray * newArr = [NSMutableArray new];
    //指定时间
    NSTimeInterval newT = now - disTime;
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i][@"timestamp"] doubleValue] > newT) {
            [newArr addObject:arr[i]];
            continue;
        }
    }
    return newArr;
}
+ (NSMutableDictionary *)getSaleData:(NSMutableArray *)dataArr
                                 day:(NSInteger)day{
    NSMutableDictionary * saleInfo = [NSMutableDictionary new];
    
    NSInteger income = 0;
    NSInteger sales = 0;
    
    for (int i  = 0; i < day; i ++) {
        income = income + [dataArr[i][@"income"] intValue];
        sales = sales + [dataArr[i][@"sales"] intValue];
    }
    [saleInfo setObject:@(income) forKey:@"income"];
    [saleInfo setObject:@(sales) forKey:@"sale"];
    return saleInfo;
}
+ (void)quickSortDataArray:(NSMutableArray *)array startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex key:(NSString *)sortKey{
    if ([sortKey isEqualToString:@""] || sortKey == nil || array.count == 0 || array == nil) {
        return;
    }
    if (startIndex >= endIndex) {
        return ;
    }
    NSInteger i = startIndex;
    NSInteger j = endIndex;
    id temp = array[i];
    NSInteger key = [temp[sortKey] integerValue];
    
    while (i < j) {
        while (i < j && [array[j][sortKey] integerValue] >= key) {
            j--;
        }
        array[i] = array[j];
        while (i < j && [array[i][sortKey] integerValue] <= key) {
            i++;
        }
        array[j] = array[i];
    }
    array[i] = temp;
    [self quickSortDataArray:array startIndex:startIndex endIndex:i - 1 key:sortKey];
    [self quickSortDataArray:array startIndex:i + 1 endIndex:endIndex key:sortKey];
}
+ (NSMutableArray *)getSortArr:(NSMutableArray *)array type:(NSInteger)index{
    if (index == 0) {
        return [array mutableCopy];
    }
    int flag = 0;
    if (index == 1) {
        flag = 1;
    }else{
        flag = 0;
    }
    
    NSMutableArray * sortArr = [NSMutableArray new];
    for (int x = 0; x < array.count; x++) {
        if ([array[x][@"isSaling"] intValue] == flag) {
            [sortArr addObject:array[x]];
        }
    }
    
    return sortArr;
}
@end
