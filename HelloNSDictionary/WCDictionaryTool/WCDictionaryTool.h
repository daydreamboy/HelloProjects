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

typedef NS_ENUM(NSUInteger, WCFlattenDictionaryOption) {
    WCFlattenDictionaryOptionOnlyDictionary = kNilOptions,
    WCFlattenDictionaryOptionOnlyDictionaryAndArray,
};

@interface WCDictionaryTool : NSObject

#pragma mark - Get Value for Key

#pragma mark > keyPath

/**
 Get a NSArray object in the dictionary for the given key/keyPath

 @param dictionary the dictionary
 @param keyPath a key or a keypath using '.'
 @return If not found the NSArray object for the key, or the object is not NSArray, just return nil
 */
+ (nullable NSArray *)arrayWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath;

/**
 Get a NSDictionary object in the dictionary for the given key/keyPath

 @param dictionary the dictionary
 @param keyPath a key or a keypath using '.'
 @return If not found the NSDictionary object for the key, or the object is not NSDictionary, just return nil
 */
+ (nullable NSDictionary *)dictWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath;

/**
 Get a NSString object in the dictionary for the given key/keyPath

 @param dictionary the dictionary
 @param keyPath a key or a keypath using '.'
 @return If not found the NSString object for the key, or the object is not NSString, just return nil
 */
+ (nullable NSString *)stringWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath;

/**
 Get a NSNumber object in the dictionary for the given key/keyPath
 
 @param dictionary the dictionary
 @param keyPath a key or a keypath using '.'
 @return If not found the NSNumber object for the key, or the object is not NSNumber, just return nil
 */
+ (nullable NSNumber *)numberWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath;

/**
 Get a object in the dictionary for the given key/keyPath

 @param dictionary the dictionary
 @param keyPath a key or a keypath using '.'
 @param objectClass the class type. Use [XXXClass class]
 @return the object at the given key/keyPath. Return nil if the object not match the objectClass or the key/keyPath
 not exists.
 */
+ (nullable id)objectWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass;

/**
 Flatten the nested dictionary into one-level dictionary

 @param dictionary the dictionary which maybe nest dictionary or array.
 @param option the option. See WCFlattenDictionaryOption
 - WCFlattenDictionaryOptionOnlyDictionary (also kNilOptions): dictionary nest dictionary
 - WCFlattenDictionaryOptionOnlyDictionaryAndArray: dictionary nest dictionary or array
 @return the flatten dictionary. The key are keyPath separated by `.`
 */
+ (nullable NSDictionary<NSString *, id> *)flattenDictionaryWithDictionary:(NSDictionary *)dictionary option:(WCFlattenDictionaryOption)option;

#pragma mark - Safe Wrapping

+ (NSDictionary *)dictionaryWithKeyAndValues:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - Modification

/**
 Remove object by key with NSDictionary or NSMutableDictionary

 @param dictionary the original dictionary is NSDictionary or NSMutableDictionary
 @param keyPath the key to remove
 @param allowMutable YES to return mutable, or NO to return immutable
 @return the modified dictionary. The returned dictionary always a new dictionary. Return nil, if parameters are wrong.
 @discussion This method not modify key-values in the parameter `dictionary`
 */
+ (nullable NSDictionary *)removeObjectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)keyPath allowMutable:(BOOL)allowMutable;

/**
 Set object for key with NSDictionary or NSMutableDictionary

 @param dictionary the original dictionary is NSDictionary or NSMutableDictionary
 @param object the object to set. If nil, the key to remove.
 @param keyPath the key to set
 @param allowMutable YES to return mutable, or NO to return immutable
 @return the modified dictionary. The returned dictionary always a new dictionary. Return nil, if parameters are wrong.
 @discussion This method not modify key-values in the parameter `dictionary`
 */
+ (nullable NSDictionary *)setObjectWithDictionary:(NSDictionary *)dictionary object:(nullable id)object forKey:(NSString *)keyPath allowMutable:(BOOL)allowMutable;

#pragma mark - Conversion (TODO)

+ (nullable NSDictionary<NSString *, id> *)transformDictionary:(NSDictionary<NSString *, id> *)dictionary usingKeysMapping:(NSDictionary<NSString *, NSString *> *)keysMapping mode:(WCKeysMappingMode)mode;

#pragma mark - Two Dictionaries Operation

#pragma mark > Merge

/**
 Merge two dictionaries

 @param dictionary1 the dictionary 1, and allow nil
 @param dictionary2 the dictionary 2, and allow nil
 @param allowMutable YES to return a mutable dictionary, NO to return an immutable dictionary
 @return the merged dictionary. Return nil if dictionary1 and dictionary2 are not NSDictionary object
 @discussion This method simply merges two dictionaries, not merges recursively
 */
+ (nullable NSDictionary *)mergedDictionaryWithDictionary1:(nullable NSDictionary *)dictionary1 dictionary2:(nullable NSDictionary *)dictionary2 allowMutable:(BOOL)allowMutable;

@end

NS_ASSUME_NONNULL_END
