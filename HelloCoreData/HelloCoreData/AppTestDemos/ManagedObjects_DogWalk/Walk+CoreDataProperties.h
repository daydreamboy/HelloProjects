//
//  Walk+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 29/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Walk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Walk (CoreDataProperties)

+ (NSFetchRequest<Walk *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) Dog *dog;

@end

NS_ASSUME_NONNULL_END
