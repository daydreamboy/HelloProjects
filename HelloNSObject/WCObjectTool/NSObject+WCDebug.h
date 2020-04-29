//
//  NSObject+WCDebug.h
//  HelloNSObject
//
//  Created by wesley_chen on 2020/4/29.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Set variable name as a property `WCDebugVariableName`
 
 @param var the variable name
 @param type the type of variable name
 @param ... the initialization clause
 
 @discussion This macro must be used with NSObject (WCDebug) category
 @code
 // TODO
 @endcode
 */
#define VAR_DEFINED_DEBUGGABLE(var, type, ...)  type var = ({ \
    NSObject *internal_object__ = (NSObject *)__VA_ARGS__; \
    if ([internal_object__ respondsToSelector:NSSelectorFromString(@"setWCDebugVariableName:")]) { \
        @try { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
            [internal_object__ performSelector:NSSelectorFromString(@"setWCDebugVariableName:") withObject:(@#var)]; \
_Pragma("clang diagnostic pop") \
        } @catch (NSException *exception) {} \
    } \
    (id)internal_object__; \
});

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (WCDebug)
@property (nonatomic, copy) NSString *WCDebugVariableName;
@end

NS_ASSUME_NONNULL_END
