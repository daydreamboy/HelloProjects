//
//  WCMacroTool.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#define STR_OF_PROP(property)    (NSStringFromSelector(@selector(property)))

#define DICT_IF_NOT_EMPTY(dict)    ([(dict) isKindOfClass:[NSDictionary class]] && [(NSDictionary *)(dict) count])

// Is a string and not empty
#define STR_IF_NOT_EMPTY(str)    ([(str) isKindOfClass:[NSString class]] && [(NSString *)(str) length])

// Is a string and empty
#define STR_IF_EMPTY(str)        ([(str) isKindOfClass:[NSString class]] && [(NSString *)(str) length] == 0)

// Is a string and empty after trim
#define STR_TRIM_IF_EMPTY(str)   ([(str) isKindOfClass:[NSString class]] && [[(NSString *)(str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)

// Is a string and not empty after trim
#define STR_TRIM_IF_NOT_EMPTY(str)   ([(str) isKindOfClass:[NSString class]] && [[(NSString *)(str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])

#pragma mark - JSON Value

#pragma mark > Safe Get JSON Value

/**
 Get value from JSON value (NSString/NSNumber)

 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @param valueType the value type expected
 @param defaultValue the default value
 @return the value
 @discussion This method gets value from NSString or NSNumber unstrictly. Otherwise, get the defaultValue
 */
#define valueOfJSONValue(JSONValue, valueType, defaultValue) (([(JSONValue) isKindOfClass:[NSString class]] || [(JSONValue) isKindOfClass:[NSNumber class]]) ? [(NSString *)(JSONValue) valueType##Value] : (defaultValue))

/**
 Get double value from JSON value (NSString/NSNumber)

 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return 0.0
 */
#define doubleValueOfJSONValue(JSONValue)   valueOfJSONValue(JSONValue, double, 0.0)
/**
 Get float value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return 0.0f
 */
#define floatValueOfJSONValue(JSONValue)    valueOfJSONValue(JSONValue, float, 0.0f)
/**
 Get int value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return 0
 */
#define intValueOfJSONValue(JSONValue)      valueOfJSONValue(JSONValue, int, 0)
/**
 Get NSInteger value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return 0
 */
#define integerValueOfJSONValue(JSONValue)  valueOfJSONValue(JSONValue, integer, 0)
/**
 Get long long value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return 0
 */
#define longLongValueOfJSONValue(JSONValue) valueOfJSONValue(JSONValue, longLong, 0LL)
/**
 Get BOOL value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return NO
 */
#define boolValueOfJSONValue(JSONValue)     valueOfJSONValue(JSONValue, bool, NO)
/**
 Get NSString value from JSON value (NSString/NSNumber)
 
 @param JSONValue the JSON value (NSString, NSNumber, NSArray, NSDictionary, or NSNull) or others
 @return the value. Unexpected JSONValue will return nil
 */
#define stringValueOfJSONValue(JSONValue)   ([(JSONValue) isKindOfClass:[NSString class]] ? (JSONValue) : ([(JSONValue) isKindOfClass:[NSNumber class]]) ? [(NSNumber *)(JSONValue) stringValue] : nil)


#endif /* WCMacroTool_h */
