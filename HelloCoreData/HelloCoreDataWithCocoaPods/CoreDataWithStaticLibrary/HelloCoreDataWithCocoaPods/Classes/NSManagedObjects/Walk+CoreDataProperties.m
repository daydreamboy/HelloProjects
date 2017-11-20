//
//  Walk+CoreDataProperties.m
//  
//
//  Created by wesley_chen on 20/11/2017.
//
//

#import "Walk+CoreDataProperties.h"

@implementation Walk (CoreDataProperties)

+ (NSFetchRequest<Walk *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Walk"];
}

@dynamic date;
@dynamic dog;

@end
