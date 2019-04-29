//
//  JYCalulateKits.h
//  RTPg
//
//  Created by tts on 2019/4/16.
//  Copyright © 2019年 tts. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JYCalulateKits : NSObject
//计算缓存
+ (NSString *)getCacheSize;
+ (void)clearCacheSizeAndCompleteBlock:(void(^)(BOOL status))completeBlock;
/*计算图片大小*/
+ (long int )calulateImageFileSize:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
