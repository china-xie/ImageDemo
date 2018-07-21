//
//  XTImagePickerViewController.h
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    theSquareIntercept   = 0,    /*! \~正方形截取 */
    theRectangleIntercept,         /*! \~长方形截取 */
    theIDCardIntercept,         /*! \~身份证截取 */
}ImageInterceptType;
@class XTImagePickerViewController;
@protocol XTImagePickerViewControllerDelegate <NSObject>

- (void)imageCropper:(XTImagePickerViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(XTImagePickerViewController *)cropperViewController;

@end


/*! @brief  图片选择控制器
 *
 */
@interface XTImagePickerViewController : UIViewController
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<XTImagePickerViewControllerDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

/// 图片截取类型
@property(nonatomic,assign)ImageInterceptType  interceptType;

- (id)initWithImage:(UIImage *)originalImage withInterceptType:(ImageInterceptType)InterceptType cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;
@end
