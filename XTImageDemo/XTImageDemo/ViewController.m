//
//  ViewController.m
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "ViewController.h"
#import "Image+CoreDataClass.h"
#import "XTImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "XTCacheManager.h"
#import "XTCenterCollectionViewCell.h"
#import "XTBottomCollectionViewCell.h"
#import "XTLineLayout.h"
#import "XTCommonTool.h"
#import "XTCoreDataManager.h"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface ViewController ()<UIImagePickerControllerDelegate,XTImagePickerViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    
    NSManagedObjectContext *context;//coredata上下文
    
}
@property (weak, nonatomic) IBOutlet UIButton *getCameraBtn;
//用户上传图片
@property(nonatomic,strong)UIImage *selectedImg;
///用户头像上传图片
@property(nonatomic,strong)UIImage * portraitImg;
@property(nonatomic,strong)NSMutableArray * imageArr;
@property(nonatomic,assign)NSInteger currentItem;
@end

@implementation ViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 获取缓存的图片
    [self getCacheImage];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCameraBtnBorder];
  
    [self setCollectionView];
   
    [self setCoreData];
    
}
// 设置拍照按钮border
-(void)setCameraBtnBorder{
    [self.getCameraBtn.layer setMasksToBounds:YES];
    [self.getCameraBtn.layer setCornerRadius:4]; //设置矩形四个圆角半径
    //边框宽度
    [self.getCameraBtn.layer setBorderWidth:2.0];
    self.getCameraBtn.layer.borderColor=[UIColor darkGrayColor].CGColor;
}
// 添加collectionView
-(void)setCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置中部CollectionView
    self.centerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 210) collectionViewLayout:flowLayout];
    self.centerCollectionView.backgroundColor = [UIColor whiteColor];
    self.centerCollectionView.delegate = self;
    self.centerCollectionView.dataSource = self;
    self.centerCollectionView.scrollEnabled = YES;
    self.centerCollectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.centerCollectionView];
    self.centerCollectionView.pagingEnabled = YES;
    //注册Cell
    [self.centerCollectionView registerClass:[XTCenterCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //设置底部CollectionView
    self.bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 120, self.view.frame.size.width, 100) collectionViewLayout:[[XTLineLayout alloc] init]];
    self.bottomCollectionView.backgroundColor = [UIColor whiteColor];
    self.bottomCollectionView.showsHorizontalScrollIndicator = NO;
    self.bottomCollectionView.delegate = self;
    self.bottomCollectionView.dataSource = self;
    self.bottomCollectionView.scrollEnabled = YES;
    [self.view addSubview:self.bottomCollectionView];
    [self.bottomCollectionView registerClass:[XTBottomCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
}


// 设置数据库
-(void)setCoreData{
//    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
//
//    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
//
//    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//
//    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Image.sqlite"]];//设置数据库的路径和文件名称和类型
//
//    // 添加持久化存储库，这里使用SQLite作为存储库
//    NSError *error = nil;
//    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
//    if (store == nil) { // 直接抛异常
//        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
//    }
//    // 初始化上下文，设置persistentStoreCoordinator属性
//    context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    context.persistentStoreCoordinator = psc;
    [[XTCoreDataManager shareInstance]getCurrentPersistentContainer];
}
#pragma mark -- scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:self.centerCollectionView]) {
        UICollectionViewCell *cell = [self getCenterCell:self.centerCollectionView];
            NSInteger item = [self.centerCollectionView indexPathForCell:cell].item;
        //
            if (item != _currentItem) {
                _currentItem = item;
                [self.bottomCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                [self.bottomCollectionView reloadData];
                
            }
    }else{
        UICollectionViewCell *cell = [self getCenterCell:self.bottomCollectionView];
        NSInteger item = [self.bottomCollectionView indexPathForCell:cell].item;
        //
        if (item != _currentItem) {
            _currentItem = item;
            [self.centerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.centerCollectionView reloadData];
            
        }
    }
   
}
// 滑动的时候判断cell
-(UICollectionViewCell *)getCenterCell:(UICollectionView *)collectionView{
    
    UICollectionViewCell * tempCell;
    for(XTBottomCollectionViewCell * cell in collectionView.visibleCells){
        CGRect rect=[collectionView convertRect:cell.frame toView:self.view];
        CGFloat rectX = CGRectGetMidX(rect);
        if((rectX >= self.view.center.x-10.0) && (rectX <= self.view.center.x+10.0) ){
            tempCell = cell;
        } else {

        }
    }
    return tempCell;
}
-(void)getCacheImage{
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    
    request.entity = [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];//找到我们的Person
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name != %@", @""];//创建谓词语句，条件是uid等于001
    request.predicate = predicate; //赋值给请求的谓词语句
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行我们的请求
  self.imageArr = [NSMutableArray array];
    for (NSManagedObject *obj in objs) {
        
 
        [self.imageArr  addObject:[obj valueForKey:@"name"]];
    }
    
  
   
    [self.centerCollectionView reloadData];
    [self.bottomCollectionView reloadData];
    NSLog(@"%zd",objs.count);
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
    }
    
    
}
- (IBAction)getImageAction:(UIButton *)sender {
    // 拍照
    
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        
        
        if ([XTCommonTool isCanUsePhotos]) {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (granted) {
                            
                            //第一次用户接受
                            
                        }else{
                            
                            //用户拒绝
                            
                            [controller dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                            
                        }
                        
                    });
                }];
            }
            
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isRearCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }else {
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请在”设置>隐私>相机中允许使用相机功能"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 if (UIApplicationOpenSettingsURLString != NULL) {
                                                                     NSURL *appSettings = [NSURL                                                                              URLWithString:UIApplicationOpenSettingsURLString];
                                                                     [[UIApplication sharedApplication] openURL:appSettings];
                                                                 }
                                                                 
                                                                 
                                                             }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * action) {
                                                                     
                                                                 }];
            
            
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:NO completion:nil];
            
        }
        
        
    }
    
    
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDatasource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.centerCollectionView]) {
         return CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height);
    }else{
        return CGSizeMake(collectionView.frame.size.width/5,collectionView.frame.size.height);
    }
    return CGSizeZero;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageArr.count>0) {
        return self.imageArr.count;
    }else{
        return 0;
    }
    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

   
    if ([collectionView isEqual:self.centerCollectionView]) {
    XTCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        
        cell.imageView.image = [[XTCacheManager shareManager]getImageWithImageName:self.imageArr[indexPath.row]];
        
        cell.timeLabel.text =   self.imageArr[indexPath.row];
  
        return cell;
        
    }else{
         XTBottomCollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        cell1.imageView.image = [[XTCacheManager shareManager]getImageWithImageName:self.imageArr[indexPath.row]];
        return cell1;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.bottomCollectionView]) {
//        UICollectionViewCell *cell = [self.bottomCollectionView cellForItemAtIndexPath:indexPath];
        NSInteger item = indexPath.item;
        //
        if (item != _currentItem) {
            _currentItem = item;
            [self.centerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.centerCollectionView reloadData];
            [self.bottomCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_currentItem inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self.bottomCollectionView reloadData];
            
        }
    }
    
    
}
#pragma mark XTImagePickerViewControllerDelegate
- (void)imageCropper:(XTImagePickerViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    XTCacheManager * CacheManager = [XTCacheManager shareManager];
    
    [CacheManager creatCacheImagePath];
    
  
    NSData*  imageData1 = UIImageJPEGRepresentation(editedImage,0.1);
    //    float length1 = [imageData1 length]/1024;
    NSString * str =[XTCommonTool getNowDateString];
    [CacheManager saveImageToCache:imageData1 withDataName:str];
    //    imageCell.leftImageView.image = editedImage;
    
    //    [self  getNowDateString];
    ///此代码等价于 ==  类的 alloc init
    NSManagedObject *s1 = [NSEntityDescription    insertNewObjectForEntityForName:@"Image" inManagedObjectContext:context];
    
    [s1 setValue:str forKey:@"name"];
    
    
    NSError *error = nil;
    
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
    }else
    {
        NSLog(@"插入成功");
        
         [self getCacheImage];
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imageCropperDidCancel:(XTImagePickerViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate   上传头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        if (![XTCommonTool isCanUsePhotos]) {
            return ;
        }
        self.portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.portraitImg = [self imageByScalingToMaxSize:self->_portraitImg];
        
        
        
        // 裁剪
        XTImagePickerViewController *imgEditorVC = [[XTImagePickerViewController alloc] initWithImage:self->_portraitImg withInterceptType:theSquareIntercept cropFrame:self.view.bounds limitScaleRatio:3.0];
        imgEditorVC.interceptType =theSquareIntercept ;
        imgEditorVC.delegate = self;
        
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
