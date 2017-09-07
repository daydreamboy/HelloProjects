//
//  Venue+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Venue+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Venue (CoreDataProperties)

+ (NSFetchRequest<Venue *> *)fetchRequest;

@property (nonatomic) BOOL favorite;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nonatomic) int32_t specialCount;
@property (nullable, nonatomic, retain) Category *category;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) PriceInfo *priceInfo;
@property (nullable, nonatomic, retain) Stats *stats;

@end

NS_ASSUME_NONNULL_END
