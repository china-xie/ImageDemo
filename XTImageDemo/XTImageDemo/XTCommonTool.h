//
//  XTCommonTool.h
//  XTImageDemo
//
//  Created by mc on 2018/7/19.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTCommonTool : NSObject
// 获取当前时间
+(NSString *)getNowDateString;
// 摄像头是否可用
+ (BOOL)isCanUsePhotos;
@end
