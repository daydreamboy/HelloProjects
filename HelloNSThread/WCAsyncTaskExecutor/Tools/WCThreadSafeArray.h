//
//  WCThreadSafeArray.h
//  HelloNSArray
//
//  Created by wesley_chen on 2019/8/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCThreadSafeArray<__covariant ObjectType> : NSObject

#pragma mark - Initialize

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithPlaceholderObject:(id)object count:(NSUInteger)count NS_DESIGNATED_INITIALIZER;
+ (instancetype)array;
+ (instancetype)arrayWithCapacity:(NSUInteger)capacity;

#pragma mark - Add

- (void)addObject:(ObjectType)object;
- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)object;
- (void)addObjectsFromArray:(WCThreadSafeArray<ObjectType> *)otherArray;
- (void)setArray:(WCThreadSafeArray<ObjectType> *)otherArray;

#pragma mark - Remove

- (void)removeAllObjects;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeObject:(ObjectType)object;

#pragma mark - Query

- (NSUInteger)count;
- (nullable ObjectType)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(ObjectType)object;
- (NSArray *)arrayRepresentation;

#pragma mark - Sort

- (void)exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;
- (void)sortUsingDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

#pragma mark - Subscript

- (nullable ObjectType)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(ObjectType)object atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
