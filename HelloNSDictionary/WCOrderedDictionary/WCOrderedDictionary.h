//
//  WCOrderedDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSArray * WCOrderedDictionaryPair;

/**
 The ordered dictionary which is ordered by the addition of the key/value
 
 @discussion The WCOrderedDictionary is mutable and not thread safe.
 */
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

/**
 Get the description as JSON format

 @return the description string.
 @discussion The normal dictionary sorted by keys
 */
- (NSString *)description;

/**
 Same as description

 @return the debug description string.
 */
- (NSString *)debugDescription;

#pragma mark - Subscript (e.g. dict[@"key"])

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

#pragma mark - Index (e.g. dict[1])

/**
 Make a pair with the key and value

 @param key the key
 @param value the value
 @return return nil if key or value is nil
 */
__nullable WCOrderedDictionaryPair WCOrderedDictionaryPairMake(KeyType key, ObjectType value);

/**
 Get a key/value pair at the index

 @param index the index which expected in [0, count)
 @return the pair object
 @discussion the pair object actually is NSArray which size is 2. The first object is key, and the second object is value
 */
- (nullable WCOrderedDictionaryPair)objectAtIndexedSubscript:(NSUInteger)index;

/**
 Set key/value pair at the index

 @param object the WCOrderedDictionaryPair object
 @param index the index which expected in [0, count)
 */
- (void)setObject:(nullable WCOrderedDictionaryPair)object atIndexedSubscript:(NSUInteger)index;

#pragma mark - Convert from NSDictionary

/**
 Convert NSDictionary to WCOrderedDictionary

 @param dictionary the original dictinary
 @return the ordered dictionary which sorted by key's description
 */
+ (nullable WCOrderedDictionary *)orderedDictionaryFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
