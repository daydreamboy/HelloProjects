//
//  WCDictionaryTool.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/6/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSDictionary_stringForKey(key, dict) ([WCDictionaryTool dictionary:(dict) stringForKey:(key)])

@interface WCDictionaryTool : NSObject

#pragma mark - Safe Access Values (NSArray, NSDictionary, NSString, NSNumber) for key/keypath

/**
 Get a NSArray object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSArray object for the key, or the object is not NSArray, just return nil
 */
+ (NSArray *)arrayWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSDictionary object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSDictionary object for the key, or the object is not NSDictionary, just return nil
 */
+ (NSDictionary *)dictWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSString object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSString object for the key, or the object is not NSString, just return nil
 */
+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

/**
 Get a NSNumber object in the dictionary for given key
 
 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSNumber object for the key, or the object is not NSNumber, just return nil
 */
+ (NSNumber *)numberWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

#pragma mark - Safe Wrapping

+ (NSDictionary *)dictionaryWithKeyAndValues:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark - JSON String to NSDictionary

/**
 Get a JSON-based NSDictionary from JSON string

 @param jsonString the JSON string
 @return return nil if jsonString is invalid
 */
+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;

#pragma mark - Mutation

/**
 Remove object by key in NSDictionary or NSMutableDictionary

 @param dictionary the dictionary is NSDictionary or NSMutableDictionary
 @param key the key to remove
 @return the modified dictionary. The returned dictionary always a new dictionary. Return nil, if parameters are wrong.
 @discussion This method not modify key-values in the parameter `dictionary`
 */
+ (NSDictionary *)removeObjectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key;

#pragma mark - Override Methods

+ (NSString *)debugDescriptionWithDictionary:(NSDictionary *)dictionary;

@end
