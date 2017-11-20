//
//  Dog+CoreDataProperties.m
//  
//
//  Created by wesley_chen on 20/11/2017.
//
//

#import "Dog+CoreDataProperties.h"

@implementation Dog (CoreDataProperties)

+ (NSFetchRequest<Dog *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Dog"];
}

@dynamic name;
@dynamic walks;

@end
