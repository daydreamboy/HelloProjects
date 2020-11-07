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

#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

#define FrameSetSize(frame, newWidth, newHeight) ({ \
CGRect __internal_frame = (frame); \
if (!isnan((newWidth))) { \
    __internal_frame.size.width = (newWidth); \
} \
if (!isnan((newHeight))) { \
    __internal_frame.size.height = (newHeight); \
} \
__internal_frame; \
})

#define UIEdgeInsetsSet(insets, newTop, newLeft, newBottom, newRight) \
({ \
UIEdgeInsets __insets = insets; \
if (!isnan((newTop))) { \
    __insets = UIEdgeInsetsMake(newTop, __insets.left, __insets.bottom, __insets.right); \
} \
if (!isnan((newLeft))) { \
    __insets = UIEdgeInsetsMake(__insets.top, newLeft, __insets.bottom, __insets.right); \
} \
if (!isnan((newBottom))) { \
    __insets = UIEdgeInsetsMake(__insets.top, __insets.left, newBottom, __insets.right); \
} \
if (!isnan((newRight))) { \
    __insets = UIEdgeInsetsMake(__insets.top, __insets.left, __insets.bottom, newRight); \
} \
\
__insets; \
});

#define DOUBLE_SAFE_MAX(a, b) \
({ \
double __returnValue; \
double __v1 = (a); \
double __v2 = (b); \
if (__v1 >= __v2) { \
    __returnValue = __v1; \
} \
else { \
    __returnValue = __v2; \
} \
__returnValue; \
});

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

#define SHOW_ALERT(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

#endif /* WCMacroTool_h */
