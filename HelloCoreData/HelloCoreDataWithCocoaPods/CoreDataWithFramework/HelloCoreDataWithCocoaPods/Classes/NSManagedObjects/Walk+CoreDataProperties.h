//
//  Walk+CoreDataProperties.h
//  
//
//  Created by wesley_chen on 20/11/2017.
//
//

#import "Walk+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Walk (CoreDataProperties)

+ (NSFetchRequest<Walk *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, retain) Dog *dog;

@end

NS_ASSUME_NONNULL_END
