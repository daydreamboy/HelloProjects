//
//  WCWeakReferenceDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 The key/value's memory semantics
 */
typedef NS_ENUM(NSUInteger, WCWeakableDictionaryKeyValueMode) {
    WCWeakableDictionaryKeyValueModeStrongToStrong,
    WCWeakableDictionaryKeyValueModeStrongToWeak,
    WCWeakableDictionaryKeyValueModeWeakToStrong,
    WCWeakableDictionaryKeyValueModeWeakToWeak,
    WCWeakableDictionaryKeyValueModeStrongToMixed,
    WCWeakableDictionaryKeyValueModeWeakToMixed,
};

NS_ASSUME_NONNULL_BEGIN

/**
 The dictionary with more key/value's memory semantics
 */
@interface WCWeakReferenceDictionary<__covariant KeyType, __covariant ObjectType> : NSObject <NSFastEnumeration>

/**
 The memory semantic mode of the key and value
 */
@property (nonatomic, readonly) WCWeakableDictionaryKeyValueMode keyValueMode;

/**
 Get all keys
 */
@property (nonatomic, readonly, copy) NSArray<KeyType> *allKeys;

/**
 Get all values
 */
@property (nonatomic, readonly, copy) NSArray<ObjectType> *allValues;

#pragma mark - Initialization

+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)weakToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)weakToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity;

+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)weakToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity;

#pragma mark - Add

- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)setWeakReferenceObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)addEntriesFromDictionary:(WCWeakReferenceDictionary<KeyType, ObjectType> *)otherDictionary;

#pragma mark - Remove

- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keys;

#pragma mark - Query

- (nullable ObjectType)objectForKey:(KeyType)key;
- (NSUInteger)count;
- (NSDictionary<KeyType, ObjectType> *)dictionaryRepresentation;

#pragma mark - Subscript

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

@end

NS_ASSUME_NONNULL_END
