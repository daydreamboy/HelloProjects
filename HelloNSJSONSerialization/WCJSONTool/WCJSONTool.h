//
//  WCJSONTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The merge mode
 
 Ovewrite mode:
 For array, must find the original item in array by counterpart index
 e.g. ["a", "b"] + [{}, "c"] => ["a", "c"],  ["a", "b"] + ["c"] => ["a", "b"]
 
 For map, must find the original entry in array by counterpart key
 e.g. {"k1":"v1"} + {"k1":"v2"} => {"k1":"v2"}, {"k1":"v1"} + {"k2":"v2"} => {"k1":"v1"}
 
 UnionSet mode:
 For array, not need find the original item in array by counterpart index, just get the unioned array
 e.g. ["a", "b"] + [{}, "c"] => ["a", "b", {}, "c"],  ["a", "b"] + ["c"] => ["a", "b", "c"]
 
 For map, not need find the original entry in array by counterpart key, just get the unioned map. If the
 keys conflict, the later to overwrite
 e.g. {"k1":"v1"} + {"k1":"v2"} => {"k1":"v2"}, {"k1":"v1"} + {"k2":"v2"} => {"k1":"v1", "k2":"v2"}
 */
typedef NS_ENUM(NSUInteger, WCJSONToolMergeMode) {
    /**
     array using overwrite mode
     map using overwrite mode
     */
    WCJSONToolMergeModeArrayOverwriteMapOverwrite,
    /**
     array using overwrite mode
     map using unionset mode
     */
    WCJSONToolMergeModeArrayOverwriteMapUnionSet,
};

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

/**
 Convert KVC object to JSON string
 
 @param KVCObject the KVC object, which allow NSDictionary/NSArray/KVC object as properties
 @param options the options
        - kNilOptions for compact string.
        - NSJSONWritingPrettyPrinted for pretty printed string.
        - NSJSONWritingSortedKeys for sorted keys.
 @param keyTreeDescription the key tree to determine which values to pull out.
 For example:
 {
    "leftHand": {
      "thumb": {"name":{}},
      "indexFinger": {"name":{}},
      "middleFinger": {"name":{}},
      "ringFinger": {"name":{}},
      "pinky": {"name":{}}
    }
 }
 The root object has `leftHand` property, the leftHand object has `thumb`/`indexFinger`/`middleFinger`/`ringFinger`/`pinky`
 which each one has a `name` property. The `name` property is a not NSDictionary/NSArray/KVC object,
 so use empty {} as key tree
 
 An example: property is NSArray
 {
   "hands": [
     {
       "name": {},
       "fingers": [
         {
           "name": {},
           "index": {}
         }
       ]
     }
   ]
 }
 
 `hands` is an array property, which each one item has `name`/`fingers`. And [] allows one more description which
 match the array property's items. If less than items count, use the last description. For example:
 {
   "hands": [
     {...}, // match item 0
     {...}, // match item 1...N
     // no more description
   ]
 }
 @return the JSON formatted string. If any error occurred, return nil.
 */
+ (nullable NSString *)JSONStringWithKVCObject:(id)KVCObject printOptions:(NSJSONWritingOptions)options keyTreeDescription:(id)keyTreeDescription;

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray (also mutable version)

+ (nullable NSArray *)JSONArrayWithString:(NSString *)string allowMutable:(BOOL)allowMutable;
+ (nullable NSDictionary *)JSONDictWithString:(NSString *)string allowMutable:(BOOL)allowMutable;

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

#pragma mark > to NSDictionary/NSArray (also mutable version)

+ (nullable NSDictionary *)JSONDictWithData:(NSData *)data allowMutable:(BOOL)allowMutable;
+ (nullable NSArray *)JSONArrayWithData:(NSData *)data allowMutable:(BOOL)allowMutable;

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

/**
 Convert JSON string to escaped string
 
 @param string the JSON string
 @return the JSON escaped string from the JSON string
 @discussion This method is expected work same as +[WCJSONTool JSONEscapedStringWithString:]
 */
+ (nullable NSString *)escapedJSONStringWithJSONString:(NSString *)string;

#pragma mark - Assistant Methods

#pragma mark > Safe JSON Object

/**
 Safe get JSON object (NSArray/NSDictionary/NSString/NSNumber/NSNull)

 @param object the any object
 @return the JSON object which is valid for +[NSJSONSerialization isValidJSONObject:]
 @discussion This method maybe return a new instance which is different from the object
 */
+ (nullable id)safeJSONObjectWithObject:(id)object;

#pragma mark > JSON Object Mutable Copy

/**
 Create a mutable copy of JSON object
 
 @param object the expected JSON object
 @param allowKVCObjects YES if allow to copy custom container object which implments NSMutableCopying
 @param allowMutableLeaves YES if make leaves mutable, e.g. NSMutableString
 
 @return the mutable copy of JSON object
 */
+ (nullable id)mutableCopiedJSONObjectWithObject:(id)object allowKVCObjects:(BOOL)allowKVCObjects allowMutableLeaves:(BOOL)allowMutableLeaves;

#pragma mark > Merge two JSON Objects

/**
 Merge two JSON Objects
 
 @param toJSONObject the JSON object which to overwrite
 @param fromJSONObject the JSON object used to overwrite if needed
 
 @return the merged JSON object
 @example
 e.g. 1
 {
     "name": "Alice",
     "job": "teacher"
 }
 {
     "name": "Bob"
 }
 =>
 {
     "name": "Bob",
     "job": "teacher"
 }
 e.g. 2
 ["1", "2", "3"]
 [{}, "22", null]
 =>
 ["1", "22", "3"]
 */
+ (nullable id)mergeToJSONObject:(id)toJSONObject fromJSONObject:(nullable id)fromJSONObject mergeMode:(WCJSONToolMergeMode)mergeMode;

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
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]", @"hash.[key]", @"array.[0]"
 @param objectClass the expected class of the returned value
 @return return nil, if the keyPath not match the JSONObject
 @note If keyPath is empty string, will return the original JSONObject
 */
+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass;

#pragma mark >> For KVC Object

/**
 Get value using keyPath from KVC object

 @param KVCObject a KVC-compliant object
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]", @"hash.[key]", @"array.[0]"
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

/**
 Replace value using keyPath from JSON object
 
 @param JSONObject a NSDictionary or a NSArray
 @param keyPath a key or a keyPath separated by `.` or `[x]`, e.g. @"hash[key]", @"array[0]", @"hash.[key]", @"array.[0]"
 @param value the value to replcae, which is not allow nil, pass [NSNull null] instead
 @return return nil, if any replacement not succeed. Return a mutable object after replacement.
 */
+ (id)replaceValueOfKVCObject:(id)JSONObject usingKeyPath:(NSString *)keyPath value:(id)value;

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

#pragma mark > JSON value comparison

/**
 Compare two numbers which maybe NSString or NSNumber

 @param JSONValue1 the value allowed in JSON
 @param JSONValue2 the value allowed in JSON
 @return the NSNumber which are @(NSOrderedAscending)/@(NSOrderedDescending)/@(NSOrderedSame)/@(NSNotFound).
 Return @(NSNotFound) if parameters are wrong.
 */
+ (NSNumber *)compareNumbersRoughlyWithJSONValue1:(id)JSONValue1 JSONValue2:(id)JSONValue2;

@end

NS_ASSUME_NONNULL_END
