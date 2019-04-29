//
//  JYCalulateKits.m
//  RTPg
//
//  Created by tts on 2019/4/16.
//  Copyright © 2019年 tts. All rights reserved.
//

#import "JYCalulateKits.h"

@implementation JYCalulateKits
#pragma mark - 计算缓存大小
+ (NSString *)getCacheSize
{
    //定义变量存储总的缓存大小
    double sumSize = 0;
    //01.获取当前图片缓存路径
    NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    //02.创建文件管理对象
    NSFileManager *filemanager = [NSFileManager defaultManager];
    //获取当前缓存路径下的所有子路径
    NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
    
    //遍历所有子文件
    for (NSString *subPath in subPaths) {
        //1）.拼接完整路径
        NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * path = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:path error:NULL];
    NSEnumerator * e = [contents objectEnumerator];
    
    for (NSString *filename in e) {
        //1）.拼接完整路径
        NSString * filePath = [path stringByAppendingPathComponent:filename];
        //2）.计算文件的大小
        long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
        //3）.加载到文件的大小
        sumSize += fileSize;
    }
    NSString * size_m = [NSString stringWithFormat:@"%.2fM",sumSize/1000000];
    return size_m;
}
+ (void)clearCacheSizeAndCompleteBlock:(void(^)(BOOL status))completeBlock{
    //获取目录下的所有文件 是一个数组。
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [paths objectAtIndex:0];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :documentPath];
    for (NSString * p in files) {
        if ([p containsString:@"plist"]) {
            NSError * error = nil ;
            NSString * path = [documentPath stringByAppendingPathComponent :p];
            if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
                [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            }
        }
    }
    //获取缓存目录
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    files = [[NSFileManager defaultManager ] subpathsAtPath :cachPath];
    for (NSString * p in files) {
        NSError * error = nil ;
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
        }
    }
    if (completeBlock) {
        completeBlock(YES);
    }
}
/*计算图片大小*/
+ (long int )calulateImageFileSize:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 1.0);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
    return dataLength;
}
@end
