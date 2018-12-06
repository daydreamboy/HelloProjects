//
//  WCJSONTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_AVAILABLE_IOS(5_0)
@interface WCJSONTool : NSObject

#pragma mark - Object to String

/**
 Convert object to JSON string

 @param object the object which can match JSON element, e.g. NSArray/NSDictionary/NSNumber/NSString/NSNull
 @param options the options
        - kNilOptions for compact string.
        - NSJSONWritingPrettyPrinted for pretty printed string.
        - NSJSONWritingSortedKeys for sorted keys.
 @return the JSON formatted string
 
 @see https://www.json.org/
 @see http://stackoverflow.com/questions/6368867/generate-json-string-from-nsdictionary
 */
+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options;

/**
 Convert any object to JSON string

 @param object the object which maybe match JSON element
 @param options the options
        - kNilOptions for compact string.
        - NSJSONWritingPrettyPrinted for pretty printed string.
        - NSJSONWritingSortedKeys for sorted keys.
 @param filterInvalidObjects YES will filter invalid objects. NO will force to convert, return nil if not valid.
 @return the JSON formatted string
 */
+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options filterInvalidObjects:(BOOL)filterInvalidObjects;

#pragma mark > Safe JSON Object

/**
 Safe get JSON object (NSArray/NSDictionary/NSString/NSNumber/NSNull)

 @param object the any object
 @return the JSON object which is valid for +[NSJSONSerialization isValidJSONObject:]
 @discussion This method maybe return a new instance which is different from the object
 */
+ (nullable id)safeJSONObjectWithObject:(id)object;

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSArray *)JSONArrayWithString:(NSString *)string;
+ (nullable NSDictionary *)JSONDictWithString:(NSString *)string;

#pragma mark > to NSMutableDictionary/NSMutableArray

+ (nullable NSMutableDictionary *)JSONMutableDictWithString:(NSString *)jsonString;
+ (nullable NSMutableArray *)JSONMutableArrayWithString:(NSString *)jsonString;

#pragma mark > to id

/**
 Convert the JSON formatted string to the object

 @param string the JSON formatted string
 @param options the NSJSONReadingOptions
 @param objectClass the class, and only for NSDictionary/NSArray/NSMutableDictionary/NSMutableArray/nil.
                    Pass nil, the return object type is not determined by the objectClass.
 @return the JSON object. If the string is not JSON formatted, return nil. If the JSON object not match the objectClass, return nil.
 */
+ (nullable id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass;

#pragma mark - Data to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSDictionary *)JSONDictWithData:(NSData *)data;
+ (nullable NSArray *)JSONArrayWithData:(NSData *)data;

#pragma mark > to NSMutableDictionary/NSMutableArray

+ (nullable NSMutableDictionary *)JSONMutableDictWithData:(NSData *)data;
+ (nullable NSMutableArray *)JSONMutableArrayWithData:(NSData *)data;

#pragma mark > to id

/**
 Convert the JSON formatted data to the object

 @param data the JSON formatted data
 @param options the NSJSONReadingOptions
 @param objectClass the class, and only for NSDictionary/NSArray/NSMutableDictionary/NSMutableArray/nil.
                    Pass nil, the return object type is not determined by the objectClass.
 @return the JSON object. If the string is not JSON formatted, return nil. If the JSON object not match the objectClass, return nil.
 */
+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass;

#pragma mark - JSON Escaped String

/**
 Convert NSString to JSON string by escaping some special characters, e.g. `\`, `"`

 @param string the JSON string
 @return the JSON escaped string from the string
 @see http://stackoverflow.com/questions/15843570/objective-c-how-to-convert-nsstring-to-escaped-json-string
 */
+ (nullable NSString *)JSONEscapedStringWithString:(NSString *)string;

#pragma mark - Assistant Methods

#pragma mark > Key Path Query

#pragma mark >> For JSON Object

+ (nullable NSArray *)arrayOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;
+ (nullable NSDictionary *)dictionaryOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;
+ (nullable NSString *)stringOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;

/**
 Get a NSInteger using keyPath, value can be a NSNumber or NSString

 @param JSONObject a NSDictionary or a NSArray
 @param keyPath a key or a keyPath separated by `.`, such as @"key1.key2.[1].key3"
 @return return NSNotFound if the value can't be evaluated as a number
 */
+ (NSInteger)integerOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;

+ (nullable NSNumber *)numberOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;
+ (BOOL)boolOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;
+ (nullable NSNull *)nullOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;

/**
 Get value using keyPath from JSON object

 @param JSONObject a NSDictionary or a NSArray
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]"
 @return return nil, if the keyPath not match the JSONObject
 @note If keyPath is empty string, will return the original JSONObject
 */
+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath;

#pragma mark >> For KVC Object

/**
 Get value using keyPath from KVC object

 @param KVCObject a KVC-compliant object
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]"
 @return return nil, if the keyPath not match the KVCObject
 @note If keyPath is empty string, will return the original KVCObject
 */
+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath;

#pragma mark > Print JSON string

/**
 Print JSON format string with a JSON Object

 @param JSONObject the JSON Object (e.g. NSDictionary/NSArray/NSString/NSNumber/NSNull)
 */
+ (void)printJSONStringFromJSONObject:(id)JSONObject;

@end

NS_ASSUME_NONNULL_END
