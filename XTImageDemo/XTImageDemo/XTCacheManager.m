//
//  XTCacheManager.m
//  XTImagePickerProject
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "XTCacheManager.h"
#define   TripImageCachePath  @"CacheImage"
@implementation XTCacheManager
+ (XTCacheManager *)shareManager{
    static XTCacheManager * FileManager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (FileManager == nil) {
            FileManager = [[XTCacheManager alloc] init];
        }
    });
    return (XTCacheManager *)FileManager;
}

// 获取cache路径
- (NSString *)getCachePath {
    // 获取Caches目录路径
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"path:%@", cachesDir);
    return cachesDir;
}
// 创建文件夹
- (void)createDirectory:(NSString *)str {
    NSString *documentsPath =[self getCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:str];
    if ([self isImageExistAtPath:iOSDirectory]) {
        return;
    }
    BOOL isSuccess = [fileManager createDirectoryAtPath:iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (isSuccess) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
}

// 判断文件是否存在
- (BOOL)isSxistAtPath:(NSString *)filePath {

    NSString *documentsPath =[self getCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory = [documentsPath stringByAppendingPathComponent:filePath];
    BOOL isExist = [fileManager fileExistsAtPath:iOSDirectory];
    return isExist;
}
/// 创建图片文件夹
-(BOOL)creatCacheImagePath{
    NSString *documentsPath =[self getCachePath];
 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSDirectory = [[documentsPath stringByAppendingPathComponent:TripImageCachePath]stringByAppendingPathComponent:@"Images"];
    
    BOOL isSuccess = [fileManager createDirectoryAtPath:iOSDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return isSuccess;
}
// 图片是否存在
//-(BOOL)isImageExistAtPath:(NSString* )imageUrl{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    UserModel * model = [UserModel shareUserModel];
//    NSString *documentsPath =[self getCachePath];
//    NSString *iOSDirectory = [[documentsPath stringByAppendingPathComponent:TripImageCachePath]stringByAppendingPathComponent:model.id];
//    //    NSString * ImagePath =   [iOSDirectory substringWithRange:NSMakeRange(imageUrl.length-28, 28)];
//
//    NSString * ImagePath2 =  [NSString stringWithFormat:@"%@/%@.png",iOSDirectory,imageUrl];
//    BOOL isExist = [fileManager fileExistsAtPath:ImagePath2];
//    return isExist;
    
//}

-(BOOL)saveImageToCache:(NSData*)data withDataName:(NSString *)fileName{
    NSString *documentsPath =[self getCachePath];

    NSString *iOSDirectory = [[documentsPath stringByAppendingPathComponent:TripImageCachePath]stringByAppendingPathComponent:@"Images"];
  
    
    NSString * ImagePath2 =  [NSString stringWithFormat:@"%@/%@.png",iOSDirectory,fileName];
    
    return  [data writeToFile:ImagePath2 atomically:NO];
    
}
-(UIImage * )getImageWithImageName:(NSString *)imageName{
    NSString *documentsPath =[self getCachePath];
    
    NSString *iOSDirectory = [[documentsPath stringByAppendingPathComponent:TripImageCachePath]stringByAppendingPathComponent:@"Images"];
    
    
    NSString * ImagePath2 =  [NSString stringWithFormat:@"%@/%@.png",iOSDirectory,imageName];

    return [UIImage imageWithContentsOfFile:ImagePath2 ];
    
}
@end
