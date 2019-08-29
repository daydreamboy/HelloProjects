//
//  WCOrderedDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCOrderedDictionary<__covariant KeyType, __covariant ObjectType> : NSObject <NSFastEnumeration>

@property (nonatomic, readonly, copy) NSArray<KeyType> *allKeys;
@property (nonatomic, readonly, copy) NSArray<ObjectType> *allValues;

#pragma mark - Initialization

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;
+ (instancetype)dictionaryWithDictionary:(WCOrderedDictionary<KeyType, ObjectType> *)dict;

#pragma mark - Add

- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)setDictionary:(WCOrderedDictionary<KeyType, ObjectType> *)otherDictionary;
- (void)addEntriesFromDictionary:(WCOrderedDictionary<KeyType, ObjectType> *)otherDictionary;

#pragma mark - Remove

- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keys;

#pragma mark - Query

- (nullable ObjectType)objectForKey:(KeyType)key;
- (NSUInteger)count;
// TODO:
- (NSString *)description;
- (NSString *)debugDescription;

#pragma mark - Subscript

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

@end

NS_ASSUME_NONNULL_END
