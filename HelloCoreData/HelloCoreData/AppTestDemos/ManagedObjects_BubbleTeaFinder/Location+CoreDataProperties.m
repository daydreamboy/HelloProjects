//
//  Location+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Location+CoreDataProperties.h"

@implementation Location (CoreDataProperties)

+ (NSFetchRequest<Location *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Location"];
}

@dynamic address;
@dynamic city;
@dynamic country;
@dynamic distance;
@dynamic state;
@dynamic zipcode;
@dynamic venue;

@end
