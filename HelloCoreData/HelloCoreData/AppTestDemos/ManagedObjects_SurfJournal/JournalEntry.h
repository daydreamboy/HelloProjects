//
//  JournalEntry+CoreDataClass.h
//  HelloCoreData
//
//  Created by wesley_chen on 18/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface JournalEntry : NSManagedObject
- (NSString *)stringForDate;
@end

NS_ASSUME_NONNULL_END

#import "JournalEntry+CoreDataProperties.h"
