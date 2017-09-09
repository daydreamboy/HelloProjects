//
//  Employee1+CoreDataProperties.h
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "Employee1+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee1 (CoreDataProperties)

+ (NSFetchRequest<Employee1 *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *about;
@property (nonatomic) BOOL active;
@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *department;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *guid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSData *picture;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nonatomic) int16_t vacationDays;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, retain) NSSet<Sale1 *> *sales;

@end

@interface Employee1 (CoreDataGeneratedAccessors)

- (void)addSalesObject:(Sale1 *)value;
- (void)removeSalesObject:(Sale1 *)value;
- (void)addSales:(NSSet<Sale1 *> *)values;
- (void)removeSales:(NSSet<Sale1 *> *)values;

@end

NS_ASSUME_NONNULL_END
