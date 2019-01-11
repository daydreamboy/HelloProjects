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
 @param objectClass the expected class of the returned value
 @return return nil, if the keyPath not match the JSONObject
 @note If keyPath is empty string, will return the original JSONObject
 */
+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass;

#pragma mark >> For KVC Object

/**
 Get value using keyPath from KVC object

 @param KVCObject a KVC-compliant object
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]"
 @param objectClass the expected class of the returned value
 @return return nil, if the keyPath not match the KVCObject
 @note If keyPath is empty string, will return the original KVCObject
 */
+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass;

/**
 Get value using keyPath from KVC object with bindings

 @param KVCObject a KVC-compliant object
 @param keyPath a key or a keyPath which supports template variables, e.g. @"A$b$c.$d" => @"ABC.D", @"A$b${c}D.$e" => @"ABCD.E"
 @param bindings the map for template variables. Pass nil to not parse template variables.
 @param objectClass the expected class of the returned value
 @return If keyPath is empty string, will return the original KVCObject
 @discussion 1. the keyPath with variables must separated by `.[]`
             2. the pattern for template variables is @"\\$(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))";
 */
+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath bindings:(nullable NSDictionary *)bindings objectClass:(nullable Class)objectClass;

#pragma mark >> For NSArray/NSDictionary

/**
 Get value from NSArray/NSDictionary with bracket path

 @param collectionObject the NSArray/NSDictionary
 @param bracketsPath the path separated by [], e.g. [0]['key1'][1]['key2']
 @param objectClass the expected class of the returned value
 @return Return nil if the value not at the bracket path
 @discussion The bracketsPath has only two types of subscript, integer or string quoted by `'`. If not match the format, return nil.
 @note If keyPath is empty string, will return the original JSONObject
 */
+ (nullable id)valueOfCollectionObject:(id)collectionObject usingBracketsPath:(NSString *)bracketsPath objectClass:(nullable Class)objectClass;

#pragma mark > Print JSON string

/**
 Print JSON format string with a JSON Object

 @param JSONObject the JSON Object (e.g. NSDictionary/NSArray/NSString/NSNumber/NSNull)
 */
+ (void)printJSONStringFromJSONObject:(id)JSONObject;

#pragma mark > Objective-C literal string

/**
 Get Objective-C literal string from JSON object

 @param JSONObject the JSON object
 @param startIndentLength the length of indent space for starting
 @param indentLength the length of indent space at every level
 @param ordered If YES, the dictionary keys are ordered, or not if NO.
 @return the Objective-C literal string
 @discussion 1. This method will keep boolean NSNumber as @YES/@NO, and numeric NSNumber as @(N).
             Other type values are kept as Objective-C literal constant value.
             2. 
 */
+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered;

/**
 Print the JSON object as Objective-C literal string

 @param JSONObject the JSON object
 */
+ (void)printLiteralStringFromJSONObject:(id)JSONObject;

@end

NS_ASSUME_NONNULL_END
