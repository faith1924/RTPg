//
//  LeanCloudInterface.m
//  ABCMobileProject
//
//  Created by md212 on 2019/4/9.
//  Copyright © 2019年 ntygdff. All rights reserved.
//

#import "LeanCloudInterface.h"
#import "AVOSCloud.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+JJ.h"
#import "LeanCloudResModel.h"
#import "CGThumbImage.h"

#define CGScreenW                [[UIScreen mainScreen] bounds].size.width
#define CGScreenH                [[UIScreen mainScreen] bounds].size.height

#define CGScale_Width            [[UIScreen mainScreen] bounds].size.width/375.00
#define CGScale_Height           [[UIScreen mainScreen] bounds].size.height/667.00
#define safeTop (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896) ? 24 : 0)
#define keyWindow      [UIApplication sharedApplication].keyWindow

static CGThumbImage * thumbImage;
static UIView * lineView ;
@implementation LeanCloudInterface
/**
 提交数据数据
 
 @param className 类名
 @param keys 关键字
 @param result 返回结果
 */
+ (void) setClassInfo:(NSString *)className
               keyDic:(NSDictionary *)keys
               result:(void(^)(BOOL))result{
    AVObject *todo = [AVObject objectWithClassName:className];
    
    for(NSString * key in keys){
        [todo setObject:[keys objectForKey:key] forKey:key];
    }
    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        result(succeeded);
    }];
}


/**
 获取数据

 @param className 类名
 @param keys 关键字
 @param result 返回结果
 */
+ (void) getClassInfo:(NSString *)className
               keyDic:(NSArray *)keys
               result:(void(^)(BOOL ,NSMutableArray *))result{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query orderByDescending:@"createdAt"];
    for(NSString * key in keys){
        [query includeKey:key];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BOOL flag = NO;
        NSMutableArray * userInfoArr = [NSMutableArray new];
        NSMutableDictionary * userInfo = [NSMutableDictionary new];
        if (!error) {
            flag = YES;
            AVObject * object = nil;
            for (int x = 0; x < objects.count; x++) {
                object = objects[x];
                for (NSString * key in keys) {
                    [userInfo setObject:[NSString stringWithFormat:@"%@",[object objectForKey:key]] forKey:key];
                }
                [userInfoArr addObject:userInfo];
            }
            result(flag,userInfoArr);
        }else{
            [LeanCloudResModel shareCloudModel].error = error;
            result(flag,userInfoArr);
        }
    }];
}

/**
 注册接口
 
 @param username 用户名
 @param password 密码
 @param email 邮箱
 @param result 返回结果
 */
+ (void) userRegesterName:(NSString *)username
                 password:(NSString *)password
                    email:(NSString *)email
                   result:(nonnull void (^)(BOOL))result{
    
    if (username && password && email) {
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        user.email = email;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            LeanCloudResModel * model = [LeanCloudResModel shareCloudModel];
            if (succeeded) {
                [LeanCloudResModel shareCloudModel].userInfo = @{@"username":user.username,
                                                                 @"password":user.password,
                                                                 @"objectId":user.objectId};
                
            } else {
                model.status = NO;
                model.error = error;
            }
            if(model.status == YES){
                [LeanCloudInterface regesterThumbClass:@"headerImage" image:[UIImage imageNamed:@""] result:^(BOOL status) {
                    result(model.status);
                }];
            }else{
                result(model.status);
            }
        }];
    }
}


/**
 登录
 
 @param username 用户名
 @param password 密码
 @param result 结果
 */
+ (void) userLoginName:(NSString *)username
              password:(NSString *)password
                result:(nonnull void (^)(BOOL))result{
    
    if (username && password) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            if (!error) {
                [LeanCloudResModel shareCloudModel].userInfo = @{@"username":user.username,
                                                                 @"password":user.password,
                                                                 @"objectId":user.objectId};
                
                [LeanCloudResModel shareCloudModel].user = user;
                [LeanCloudResModel shareCloudModel].status = YES;
                
            } else {
                [LeanCloudResModel shareCloudModel].status = NO;
                [LeanCloudResModel shareCloudModel].error = error;
            }
            result([LeanCloudResModel shareCloudModel].status);
        }];
    }
}

/**
 获取图片
 
 @param className 用户名
 @param result 结果
 */
+ (void) getUserThumbClass:(NSString *)className
                    result:(void(^)(BOOL status))result{
    AVQuery *query = [AVQuery queryWithClassName:className];
    [query whereKey:@"thumbId" equalTo:[LeanCloudResModel shareCloudModel].user.objectId];
    [query includeKey:@"thumbImg"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError * _Nullable error) {
       
        if (error) {
            result(NO);
        }
        
        if ([objects isKindOfClass:[NSArray class]] && objects.count > 0) {
            AVObject *todo = objects[0];
            AVFile * file = [todo objectForKey:@"thumbImg"];
            
            if (file) {
                [LeanCloudResModel shareCloudModel].thumbImg = [NSString stringWithFormat:@"%@",file.url];
                result(YES);
            }else{
                result(NO);
            }
        }else{
            result(NO);
        }
    }];
}


/**
 修改类参数值

 @param className 雷鸣
 @param dic 关键字
 @param result 回调
 */
+ (void) updataDataClass:(NSString *)className
               updataDic:(NSDictionary *)dic
                  result:(void(^)(BOOL status))result{
    AVObject *todo =[AVObject objectWithClassName:className objectId:[LeanCloudResModel shareCloudModel].objectId];
    // 修改属性
    for (NSString * key in dic.allKeys) {
        [todo setObject:[NSString stringWithFormat:@"%@",dic[key]] forKey:key];
    }
    // 保存到云端
    [todo saveInBackground];
    result(YES);
}

/**
 上传图片
 
 @param className 用户名
 @param image 上传的图片
 @param result 结果
 */
+ (void) uploadThumbClass:(NSString *)className
                    image:(UIImage *)image
                    result:(void(^)(BOOL status))result{
    NSData *data = UIImagePNGRepresentation(image);
    AVFile *file = [AVFile fileWithData:data];
    
    AVObject *product = [AVObject objectWithClassName:className];
    [product setObject:file forKey:@"thumbImg"];

    AVQuery *query = [[AVQuery alloc] init];
    [query whereKey:@"thumbId" equalTo:[NSString stringWithFormat:@"%@",[LeanCloudResModel shareCloudModel].objectId]];
    
    AVSaveOption *option = [[AVSaveOption alloc] init];
    option.query = query;
    option.fetchWhenSave = YES;
    
    [product saveInBackgroundWithOption:option block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            [MBProgressHUD showSuccess:@"上传成功"];
            result(YES);
        } else {
//            [MBProgressHUD showError:@"上传失败!"];
            result(NO);
        }
    }];
}

/**
 初次上传图片
 
 @param className 用户名
 @param image 上传的图片
 @param result 结果
 */
+ (void) regesterThumbClass:(NSString *)className
                      image:(UIImage *)image
                     result:(void(^)(BOOL status))result{
    
    NSData *data = UIImagePNGRepresentation(image);
    AVFile *file = [AVFile fileWithData:data];
    AVObject *product = [AVObject objectWithClassName:className];
    [product setObject:[LeanCloudResModel shareCloudModel].objectId forKey:@"thumbId"];
    [product setObject:file forKey:@"thumbImg"];
    
    [product setObject:[AVUser currentUser] forKey:@"owner"];// 这里就是一个 Pointer 类型，指向当前登录的用户
    
    [product saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            [MBProgressHUD showSuccess:@"success"];
            result(YES);
        } else {
//            [MBProgressHUD showError:@"failure"];
            result(NO);
        }
    }];
}

+ (void)logout{
    [AVUser logOut];
    if (![LeanCloudResModel shareCloudModel].status == YES) {
     
    }else{
        [LeanCloudResModel shareCloudModel].status = NO;
        return;
    }
}
+ (void) updataObjectID:(NSString *)thumb{
    if (![thumb isEqualToString:@""] && [LeanCloudResModel shareCloudModel].sex) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGScreenW, safeTop)];
        lineView.backgroundColor = [UIColor whiteColor];
        [keyWindow addSubview:lineView];
        [keyWindow bringSubviewToFront:lineView];
        
        thumbImage = [[CGThumbImage alloc]initWithFrame:CGRectMake(0, safeTop, CGScreenW, CGScreenH - safeTop)];
        thumbImage.thumb = thumb;
        [keyWindow addSubview:thumbImage];
        [keyWindow bringSubviewToFront:thumbImage];
    }
}
@end
