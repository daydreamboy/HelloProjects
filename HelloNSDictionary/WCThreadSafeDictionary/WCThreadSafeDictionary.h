//
//  WCThreadSafeDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCThreadSafeDictionaryKeyValueMode) {
    WCThreadSafeDictionaryKeyValueModeObjectToObject,
    WCThreadSafeDictionaryKeyValueModePrimitiveToObject,
    WCThreadSafeDictionaryKeyValueModeObjectToPrimitive,
    WCThreadSafeDictionaryKeyValueModePrimitiveToPrimitive,
};

@interface WCThreadSafeDictionary : NSObject

- (instancetype)initWithKeyValueMode:(WCThreadSafeDictionaryKeyValueMode)mode;
+ (instancetype)dictionary;

- (nullable const void *)objectForKey:(const void *)key;
- (void)setObject:(nullable const void *)object forKey:(const void *)key;
- (void)removeAllObjects;
- (void)removeObjectForKey:(const void *)key;
- (NSUInteger)count;

#pragma mark - Subscripting

- (nullable const void *)objectForKeyedSubscript:(const void *)key;
- (void)setObject:(nullable const void *)object forKeyedSubscript:(const void *)key;

@end

NS_ASSUME_NONNULL_END
