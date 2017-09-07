//
//  Team+CoreDataProperties.m
//  HelloCoreData
//
//  Created by wesley_chen on 06/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Team+CoreDataProperties.h"

@implementation Team (CoreDataProperties)

+ (NSFetchRequest<Team *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Team"];
}

@dynamic imageName;
@dynamic losses;
@dynamic qualifyingZone;
@dynamic teamName;
@dynamic wins;

@end
