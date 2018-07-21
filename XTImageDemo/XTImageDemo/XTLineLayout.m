//
//  XTLineLayout.m
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//
#import "XTLineLayout.h"


#define kMinItemWidth 50.0
#define kMinItemHeight 80.0
#define kMaxItemWidth  kMinItemWidth*1
#define kMaxItemHeight kMinItemHeight*1


@implementation XTLineLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

/**
 * 准备操作：一般在这里设置一些初始化参数
 */
- (void)prepareLayout
{
    // 必须要调用父类(父类也有一些准备操作)
    [super prepareLayout];
    
    // 设置滚动方向(只有流水布局才有这个属性)
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置cell的大小
    self.itemSize = CGSizeMake(kMinItemWidth, kMinItemHeight);
    
    // 设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - kMinItemWidth) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);

    self.minimumLineSpacing = 5.0;
    self.minimumInteritemSpacing = 5.0;
    
}

/**
 * 决定了cell怎么排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 调用父类方法拿到默认的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 获得collectionView最中间的x值
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在默认布局属性基础上进行微调
    CGFloat distanceThreshold  = self.itemSize.width+self.minimumLineSpacing;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            CGFloat distance = ABS(attributes.center.x-centerX);
            CGFloat percentage = distance/distanceThreshold;
            CGFloat scale = 1.2+0.5*(1-percentage);
            
            if (distance <= 0.5*distanceThreshold){
                attributes.zIndex = 1000000;
            }
            else{
                attributes.zIndex = -1000000;
            }
        
            if (distance <= distanceThreshold) {
                attributes.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }
            
            
        }
    }

    return array;
}

/**
 * 当uicollectionView的bounds发生改变时，是否要刷新布局
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/**
 * targetContentOffset ：通过修改后，collectionView最终的contentOffset(取决定情况)
 * proposedContentOffset ：默认情况下，collectionView最终的contentOffset
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算最终的可见范围
    CGRect rect;
    rect.origin = proposedContentOffset;
    rect.size = self.collectionView.frame.size;
    
    // 取得cell的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最终中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 计算最小的间距值
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(attrs.center.x - centerX)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    
    // 在原有offset的基础上进行微调
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}
@end
