//
//  Sale1+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Sale1+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Sale1 (CoreDataProperties)

+ (NSFetchRequest<Sale1 *> *)fetchRequest;

@property (nonatomic) int16_t amount;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) Employee1 *employee;

@end

NS_ASSUME_NONNULL_END
