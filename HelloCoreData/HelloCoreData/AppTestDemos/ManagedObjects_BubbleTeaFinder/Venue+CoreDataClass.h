//
//  Venue+CoreDataClass.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Location, PriceInfo, Stats;

NS_ASSUME_NONNULL_BEGIN

@interface Venue : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Venue+CoreDataProperties.h"
