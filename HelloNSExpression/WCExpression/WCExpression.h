//
//  WCExpression.h
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCExpression : NSObject

/**
 The format string
 */
@property (nonatomic, copy, readonly, nullable) NSString *formatString;

/**
 The prefix for class category methods. Default is empty.
    - key, NSStringFromClass(XXX)
    - value, the prefix for the XXX class
 
 @discussion For safety, you should specify a prefix for the system class category methods
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *categoryMethodPrefixTable;

/**
 The FUNCTION name mapping to the native method name. Default is empty.
 
 @discussion The mapping operation is prior to the prefixing operation, prefixing always after mapping.
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *functionNameMapping;

/**
 Logging for debug
 */
@property (nonatomic, assign) BOOL enableLogging;

/**
 Get an expression with format string

 @param format the format string
 @return the instance of WCExpression
 */
+ (instancetype)expressionWithFormat:(NSString *)format, ...;

/**
 Get value of the expression

 @param object the object to bind, e.g. NSDictionary
 @param context the context
 @return the value which evaluate the expression. Return nil if the expression is malformed.
 */
- (nullable id)expressionValueWithObject:(nullable id)object context:(nullable NSMutableDictionary *)context;

#pragma mark - Deprecated

+ (instancetype)new NS_UNAVAILABLE; ///< Use expressionWithFormat: instead
- (instancetype)init NS_UNAVAILABLE; ///< Use expressionWithFormat: instead

@end

NS_ASSUME_NONNULL_END
