//
//  XTCacheManager.h
//  XTImagePickerProject
//    
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <UIKit/UIKit.h>
@interface XTCacheManager : NSObject
// 单例
+ (XTCacheManager *)shareManager;
- (NSString *)getCachePath;
// 创建文件夹
- (void)createDirectory:(NSString *)str;
// 判断文件是否存在
- (BOOL)isSxistAtPath:(NSString *)filePath;
// 判断图片是否存在
-(BOOL)isImageExistAtPath:(NSString* )imageUrl;
// 创建相册文件
-(BOOL)creatCacheImagePath;
// 将图片保存到沙盒
-(BOOL)saveImageToCache:(NSData*)data withDataName:(NSString *)fileName;


// 根据地址获取图片
-(UIImage * )getImageWithImageName:(NSString *)imageName;
@end
