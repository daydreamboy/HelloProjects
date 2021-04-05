//
//  WCLLDBTool.h
//  HelloLLDB
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLLDBTool : NSObject

#pragma mark - String

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

#pragma mark > Output to File

+ (BOOL)dumpString:(NSString *)string outputToFileName:(nullable NSString *)fileName;

+ (BOOL)dumpData:(NSData *)data outputToFileName:(nullable NSString *)fileName extension:(nullable NSString *)extension;

#pragma mark > Read String from File

/**
 Read string from home file
 
 @param inputFileName the home file. For simulator, located in ~. For device, located in NSHomeDirectory()
 
 @return the content of the file
 
 @warning Use this method in LLDB, should copy the returned NSString, or maybe cause to crash
 @code
 e someStringToOverwrite = (id)[(id)[WCLLDBTool stringWithInputFileName:nil] copy]
 */
+ (nullable NSString *)stringWithInputFileName:(nullable NSString *)inputFileName;

#pragma mark - Color

#pragma mark > UIColor to NSString

+ (nullable NSString *)RGBHexStringFromUIColor:(UIColor *)color;
+ (nullable NSString *)RGBAHexStringFromUIColor:(UIColor *)color;

#pragma mark > NSString to UIColor

/**
 Convert hex string to UIColor
 
 @param string the hex string with foramt @"#RRGGBB" or @"#RRGGBBAA"
 @return the UIColor object. return nil if string is not valid.
 */
+ (nullable UIColor *)colorWithHexString:(NSString *)string;
+ (nullable UIColor *)colorWithHexString:(NSString *)string prefix:(nullable NSString *)prefix;

#pragma mark - Array

#pragma mark > Filter

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4;
+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5;

#pragma mark > Output to File

+ (BOOL)iterateArray:(NSArray *)array keyPath:(NSString *)keyPath outputToFileName:(nullable NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
