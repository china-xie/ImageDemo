//
//  Image+CoreDataProperties.h
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//
//

#import "Image+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
