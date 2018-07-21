//
//  XTCenterCollectionViewCell.m
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//

#import "XTCenterCollectionViewCell.h"

@implementation XTCenterCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        [self addSubview:self.timeLabel];
        self.timeLabel.textColor = [UIColor blackColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, self.frame.size.width-20 , self.frame.size.height-50)];
        [self addSubview:self.imageView];
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
