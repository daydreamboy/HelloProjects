//
//  WCWeakReferenceDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 WC_RESTRICT_SUBCLASSING
 
 Disable the class for subclassing
 */
#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define WC_RESTRICT_SUBCLASSING __attribute__((objc_subclassing_restricted))
#else
#define WC_RESTRICT_SUBCLASSING
#endif

/**
 The key/value's memory semantics
 */
typedef NS_ENUM(NSUInteger, WCWeakableDictionaryKeyValueMode) {
    WCWeakableDictionaryKeyValueModeStrongToStrong,
    WCWeakableDictionaryKeyValueModeStrongToWeak,
    WCWeakableDictionaryKeyValueModeStrongToMixed,
};

NS_ASSUME_NONNULL_BEGIN

/**
 The dictionary which can weakly/strongly or mixed hold the values
 
 @discussion This dictionary is simular with NSMapTable, but use NSMutableDictionary instead of NSMapTable,
 for some reason see the http://cocoamine.net/blog/2013/12/13/nsmaptable-and-zeroing-weak-references/
 */
WC_RESTRICT_SUBCLASSING
@interface WCWeakReferenceDictionary<__covariant KeyType, __covariant ObjectType> : NSObject <NSFastEnumeration>

/**
 The memory semantic mode of the key/value
 */
@property (nonatomic, readonly) WCWeakableDictionaryKeyValueMode keyValueMode;

/**
 Get all keys
 */
@property (nonatomic, readonly, copy) NSArray<KeyType> *allKeys;

/**
 Get all values
 
 @discussion The number of values maybe not equal to the number of keys
 */
@property (nonatomic, readonly, copy) NSArray<ObjectType> *allValues;

#pragma mark - Initialization

+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity;
+ (WCWeakReferenceDictionary<KeyType, ObjectType> *)strongToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity;

#pragma mark - Add

/**
 Set key/value according to the keyValueMode

 @param object The object which strongly or weakly hold
 @param key The key which always strongly hold
 @param weaklyHoldInMixedMode The flag only for WCWeakableDictionaryKeyValueModeStrongToMixed mode.
 If YES, the object weakly hold. If NO, the object strongly hold.
 
 @discussion This method considers which keyValueMode is using:
 - WCWeakableDictionaryKeyValueModeStrongToStrong, object strongly hold
 - WCWeakableDictionaryKeyValueModeStrongToWeak, object weakly hold and ignore weaklyHoldInMixedMode paramter
 - WCWeakableDictionaryKeyValueModeStrongToMixed, object weakly/strongly hold determined by weaklyHoldInMixedMode paramter
 */
- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key weaklyHoldInMixedMode:(BOOL)weaklyHoldInMixedMode;

#pragma mark - Remove

- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keys;

#pragma mark - Query

- (nullable ObjectType)objectForKey:(KeyType)key;

/**
 The count of the key/values

 @return the number of the key/values
 
 @discussion This method calculate the number of keys even though the values is nil after release.
 Use -[WCWeakReferenceDictionary allValues] to check how many values still are alive.
 */
- (NSUInteger)count;
- (NSDictionary<KeyType, ObjectType> *)dictionaryRepresentation;
- (NSString *)description;

#pragma mark - Subscript

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;

/**
 The subscript to set key/value

 @param object The object which strongly or weakly hold
 @param key The key which always strongly hold
 
 @discussion This method works as -[setObject:object forKey:key objectWeakHoldInMixedMode:NO].
 See -[WCWeakReferenceDictionary setObject:forKey:objectWeakHoldInMixedMode:] for detail.
 */
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

@end

NS_ASSUME_NONNULL_END
