//
//  WCDictionaryTool.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/6/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSDictionary_stringForKey(key, dict) ([WCDictionaryTool dictionary:(dict) stringForKey:(key)])

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCKeysMappingMode) {
    WCKeysMappingModeIgnoreKeysIfNotSet,
    WCKeysMappingModeKeepKeysIfNotSet,
};

@interface WCDictionaryTool : NSObject

#pragma mark - Get Value for Key

#pragma mark > keypath

/**
 Get a NSArray object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSArray object for the key, or the object is not NSArray, just return nil
 */
+ (nullable NSArray *)arrayWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSDictionary object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSDictionary object for the key, or the object is not NSDictionary, just return nil
 */
+ (nullable NSDictionary *)dictWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSString object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSString object for the key, or the object is not NSString, just return nil
 */
+ (nullable NSString *)stringWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSNumber object in the dictionary for given key
 
 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSNumber object for the key, or the object is not NSNumber, just return nil
 */
+ (nullable NSNumber *)numberWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

+ (nullable id)objectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key objectClass:(Class)objectClass;

#pragma mark - Safe Wrapping

+ (NSDictionary *)dictionaryWithKeyAndValues:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Modification

/**
 Remove object by key with NSDictionary or NSMutableDictionary

 @param dictionary the original dictionary is NSDictionary or NSMutableDictionary
 @param key the key to remove
 @param allowMutable YES to return mutable, or NO to return immutable
 @return the modified dictionary. The returned dictionary always a new dictionary. Return nil, if parameters are wrong.
 @discussion This method not modify key-values in the parameter `dictionary`
 */
+ (nullable NSDictionary *)removeObjectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key allowMutable:(BOOL)allowMutable;

/**
 Set object for key with NSDictionary or NSMutableDictionary

 @param dictionary the original dictionary is NSDictionary or NSMutableDictionary
 @param object the object to set. If nil, the key to remove.
 @param key the key to set
 @param allowMutable YES to return mutable, or NO to return immutable
 @return the modified dictionary. The returned dictionary always a new dictionary. Return nil, if parameters are wrong.
 @discussion This method not modify key-values in the parameter `dictionary`
 */
+ (nullable NSDictionary *)setObjectWithDictionary:(NSDictionary *)dictionary object:(nullable id)object forKey:(NSString *)key allowMutable:(BOOL)allowMutable;

#pragma mark - Conversion

+ (nullable NSDictionary<NSString *, id> *)transformDictionary:(NSDictionary<NSString *, id> *)dictionary usingKeysMapping:(NSDictionary<NSString *, NSString *> *)keysMapping mode:(WCKeysMappingMode)mode;


@end

NS_ASSUME_NONNULL_END
