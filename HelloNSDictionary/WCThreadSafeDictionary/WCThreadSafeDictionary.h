//
//  WCThreadSafeDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCThreadSafeDictionary<__covariant KeyType, __covariant ObjectType> : NSObject //<NSFastEnumeration>

- (instancetype)init;
+ (instancetype)dictionary;

- (nullable ObjectType)objectForKey:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKey:(KeyType)key;
- (void)removeAllObjects;
- (void)removeObjectForKey:(KeyType)key;
- (NSUInteger)count;

#pragma mark - Subscripting

- (nullable ObjectType)objectForKeyedSubscript:(KeyType)key;
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType)key;

//#pragma mark - Fast enumeration

@end

NS_ASSUME_NONNULL_END
