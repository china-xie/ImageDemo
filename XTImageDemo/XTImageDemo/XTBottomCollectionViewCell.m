//
//  bottomCollectionViewCell.m
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "XTBottomCollectionViewCell.h"

@implementation XTBottomCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.width-20 , self.frame.size.height-10)];
        [self addSubview:self.imageView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
