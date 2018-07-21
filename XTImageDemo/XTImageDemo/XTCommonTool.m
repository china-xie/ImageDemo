//
//  XTCommonTool.m
//  XTImageDemo
//
//  Created by mc on 2018/7/19.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "XTCommonTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
@implementation XTCommonTool
+(NSString *)getNowDateString{
    NSString *timeString = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmssS"];
    timeString = [formatter stringFromDate:date];
    
    return timeString;
}
+ (BOOL)isCanUsePhotos {
    
    
    // 用户是否允许摄像头使用
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    // 不允许弹出提示框
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        return NO;
    }else{
        // 这里是摄像头可以使用的处理逻辑
        return YES;
    }
    return YES;
}
@end
