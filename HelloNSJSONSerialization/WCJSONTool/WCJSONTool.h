//
//  WCJSONTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (WCJSONTool)
#pragma mark - JSON String
/// Get a json string of NSArray with plain style
- (NSString *)JSONString;
/// Get a json string of NSArray with readable style
- (NSString *)JSONStringWithReadability;

@end

@interface NSDictionary (WCJSONTool)
#pragma mark - JSON string
- (NSString *)JSONString;
- (NSString *)JSONStringWithReadability;
@end

NS_AVAILABLE_IOS(5_0)
@interface WCJSONTool : NSObject

#pragma mark - Object to String

/**
 Convert object to JSON string

 @param object the object which can match JSON element, e.g. NSArray/NSDictionary/NSNumber/NSString/NSNull
 @param options the options, kNilOptions for compact string.
 @return the JSON formatted string
 
 @see https://www.json.org/
 @see http://stackoverflow.com/questions/6368867/generate-json-string-from-nsdictionary
 */
+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options;

/**
 Convert any object to JSON string

 @param object the object which maybe match JSON element
 @param options the options, kNilOptions for compact string.
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
 @param objectClass the class, and only for NSDictionary/NSArray/NSMutableDictionary/NSMutableArray
 @return the JSON object. If the string is not JSON formatted, return nil. If the JSON object not match the objectClass, return nil.
 */
+ (nullable id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)options objectClass:(Class)objectClass;

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
 @param objectClass the class, and only for NSDictionary/NSArray/NSMutableDictionary/NSMutableArray
 @return the JSON object. If the string is not JSON formatted, return nil. If the JSON object not match the objectClass, return nil.
 */
+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(Class)objectClass;

#pragma mark - JSON Escaped String

/**
 Convert NSString to JSON string by escaping some special characters, e.g. `\`, `"`

 @param string the JSON string
 @return the JSON escaped string from the string
 @see http://stackoverflow.com/questions/15843570/objective-c-how-to-convert-nsstring-to-escaped-json-string
 */
+ (nullable NSString *)JSONEscapedStringWithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
