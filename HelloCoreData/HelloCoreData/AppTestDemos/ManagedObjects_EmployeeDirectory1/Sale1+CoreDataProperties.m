//
//  Sale1+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Sale1+CoreDataProperties.h"

@implementation Sale1 (CoreDataProperties)

+ (NSFetchRequest<Sale1 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Sale1"];
}

@dynamic amount;
@dynamic date;
@dynamic employee;

@end
