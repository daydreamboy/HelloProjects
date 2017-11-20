//
//  Dog+CoreDataProperties.h
//  
//
//  Created by wesley_chen on 20/11/2017.
//
//

#import "Dog+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Dog (CoreDataProperties)

+ (NSFetchRequest<Dog *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSOrderedSet<Walk *> *walks;

@end

@interface Dog (CoreDataGeneratedAccessors)

- (void)insertObject:(Walk *)value inWalksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromWalksAtIndex:(NSUInteger)idx;
- (void)insertWalks:(NSArray<Walk *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeWalksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInWalksAtIndex:(NSUInteger)idx withObject:(Walk *)value;
- (void)replaceWalksAtIndexes:(NSIndexSet *)indexes withWalks:(NSArray<Walk *> *)values;
- (void)addWalksObject:(Walk *)value;
- (void)removeWalksObject:(Walk *)value;
- (void)addWalks:(NSOrderedSet<Walk *> *)values;
- (void)removeWalks:(NSOrderedSet<Walk *> *)values;

@end

NS_ASSUME_NONNULL_END
