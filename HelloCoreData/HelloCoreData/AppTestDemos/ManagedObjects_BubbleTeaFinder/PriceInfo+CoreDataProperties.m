//
//  PriceInfo+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PriceInfo+CoreDataProperties.h"

@implementation PriceInfo (CoreDataProperties)

+ (NSFetchRequest<PriceInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PriceInfo"];
}

@dynamic priceCategory;
@dynamic venue;

@end
