//
//  Note+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 11/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

+ (NSFetchRequest<Note *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Note"];
}

@dynamic body;
@dynamic dateCreated;
@dynamic displayIndex;
@dynamic title;
@dynamic image;

@end
