//
//  WCLLDBTool.h
//  HelloLLDB
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLLDBTool : NSObject

#pragma mark - String

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

#pragma mark - Array

#pragma mark > Filter

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

@end

NS_ASSUME_NONNULL_END
