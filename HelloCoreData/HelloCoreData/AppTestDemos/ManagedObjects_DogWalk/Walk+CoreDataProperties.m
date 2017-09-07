//
//  Walk+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Walk+CoreDataProperties.h"

@implementation Walk (CoreDataProperties)

+ (NSFetchRequest<Walk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Walk"];
}

@dynamic date;
@dynamic dog;

@end
