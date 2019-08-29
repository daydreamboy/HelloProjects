//
//  WCThreadSafeDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The thread safe dictionary
 
 @discussion For simplicity, WCThreadSafeDictionary not support fast enumeration (for-in)
 @warning The initialize methods is not thread safe
 */
@interface WCThreadSafeDictionary<__covariant KeyType, __covariant ObjectType> : NSObject

#pragma mark - Initialize

- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
+ (instancetype)dictionary;
+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity;

#pragma mark - Access

- (nullable ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (NSUInteger)count;

#pragma mark - Subscript

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

@end

NS_ASSUME_NONNULL_END
