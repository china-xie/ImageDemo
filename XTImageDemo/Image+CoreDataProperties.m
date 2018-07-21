//
//  Image+CoreDataProperties.m
//  XTImageDemo
//
//  Created by mc on 2018/7/18.
//  Copyright © 2018年 carlt. All rights reserved.
//
//

#import "Image+CoreDataProperties.h"

@implementation Image (CoreDataProperties)

+ (NSFetchRequest<Image *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Image"];
}

@dynamic name;

@end
