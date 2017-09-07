//
//  Stats+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Stats+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Stats (CoreDataProperties)

+ (NSFetchRequest<Stats *> *)fetchRequest;

@property (nonatomic) int32_t checkingsCount;
@property (nonatomic) int32_t tipCount;
@property (nonatomic) int32_t usersCount;
@property (nullable, nonatomic, retain) Venue *venue;

@end

NS_ASSUME_NONNULL_END
