//
//  WCThreadSafeDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
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

NS_ASSUME_NONNULL_BEGIN

/**
 The thread safe mutable dictionary
 
 @warning The initialize methods is not thread safe
 
 @see https://www.guiguan.net/ggmutabledictionary-thread-safe-nsmutabledictionary/
 */
WC_RESTRICT_SUBCLASSING
@interface WCThreadSafeDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

/**
 Get all keys
 
 @discussion the keys not copied
 */
@property (nonatomic, copy, readonly) NSArray<KeyType> *allKeys;
/**
 Get all values
 
 @discussion the values not copied
 */
@property (nonatomic, copy, readonly) NSArray<KeyType> *allValues;

#pragma mark - Initialize

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;

#pragma mark - Access

- (nullable ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (void)removeObjectsForKeys:(NSArray<KeyType> *)keys;
- (NSUInteger)count;

#pragma mark - Subscript

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

#pragma mark - Fast enumeration (NSFastEnumeration)

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(ObjectType _Nullable __unsafe_unretained [_Nonnull])buffer count:(NSUInteger)len;
@end

NS_ASSUME_NONNULL_END
