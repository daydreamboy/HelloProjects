//
//  Employee1+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Employee1+CoreDataProperties.h"

@implementation Employee1 (CoreDataProperties)

+ (NSFetchRequest<Employee1 *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Employee1"];
}

@dynamic about;
@dynamic active;
@dynamic address;
@dynamic department;
@dynamic email;
@dynamic guid;
@dynamic name;
@dynamic picture;
@dynamic startDate;
@dynamic vacationDays;
@dynamic phone;
@dynamic sales;

@end
