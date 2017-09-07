//
//  Venue+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Venue+CoreDataProperties.h"

@implementation Venue (CoreDataProperties)

+ (NSFetchRequest<Venue *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Venue"];
}

@dynamic favorite;
@dynamic name;
@dynamic phone;
@dynamic specialCount;
@dynamic category;
@dynamic location;
@dynamic priceInfo;
@dynamic stats;

@end
