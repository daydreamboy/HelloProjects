//
//  PriceInfo+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "PriceInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PriceInfo (CoreDataProperties)

+ (NSFetchRequest<PriceInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *priceCategory;
@property (nullable, nonatomic, retain) Venue *venue;

@end

NS_ASSUME_NONNULL_END
