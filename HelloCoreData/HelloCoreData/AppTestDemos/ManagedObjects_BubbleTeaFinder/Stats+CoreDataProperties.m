//
//  Stats+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Stats+CoreDataProperties.h"

@implementation Stats (CoreDataProperties)

+ (NSFetchRequest<Stats *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Stats"];
}

@dynamic checkingsCount;
@dynamic tipCount;
@dynamic usersCount;
@dynamic venue;

@end
