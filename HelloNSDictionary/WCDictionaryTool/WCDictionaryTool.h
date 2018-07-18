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
+ (NSArray *)dictionary:(NSDictionary *)dictionary arrayForKey:(NSString *)key;

/**
 Get a NSDictionary object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSDictionary object for the key, or the object is not NSDictionary, just return nil
 */
+ (NSDictionary *)dictionary:(NSDictionary *)dictionary dictForKey:(NSString *)key;

/**
 Get a NSString object in the dictionary for given key

 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSString object for the key, or the object is not NSString, just return nil
 */
+ (NSString *)dictionary:(NSDictionary *)dictionary stringForKey:(NSString *)key;

/**
 Get a NSNumber object in the dictionary for given key
 
 @param dictionary the dictionary
 @param key a key or a keypath using '.'
 @return If not found the NSNumber object for the key, or the object is not NSNumber, just return nil
 */
+ (NSNumber *)dictionary:(NSDictionary *)dictionary numberForKey:(NSString *)key;

#pragma mark - Safe Wrapping

+ (NSDictionary *)dictionaryWithKeyAndValues:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Get a JSON-based NSDictionary from JSON string

 @param jsonString the JSON string
 @return return nil if jsonString is invalid
 */
+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString;

#pragma mark - Override Methods

+ (NSString *)debugDescriptionWithDictionary:(NSDictionary *)dictionary;

@end
