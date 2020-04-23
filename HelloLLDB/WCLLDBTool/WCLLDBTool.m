//
//  WCLLDBTool.m
//  HelloLLDB
//
//  Created by wesley_chen on 2020/3/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLLDBTool.h"

@implementation WCLLDBTool

#pragma mark - String

+ (NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 {
    return [self stringWithFormat:format arg1:arg1 arg2:nil arg3:nil arg4:nil arg5:nil];
}

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 {
    return [self stringWithFormat:format arg1:arg1 arg2:arg2 arg3:nil arg4:nil arg5:nil];
}

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 {
    return [self stringWithFormat:format arg1:arg1 arg2:arg2 arg3:arg3 arg4:nil arg5:nil];
}

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 {
    return [self stringWithFormat:format arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:nil];
}

+ (nullable NSString *)stringWithFormat:(NSString *)format arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5 {
    if (![format isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (arg5) {
        return [NSString stringWithFormat:format, arg1, arg2, arg3, arg4, arg5];
    }
    
    if (arg4) {
        return [NSString stringWithFormat:format, arg1, arg2, arg3, arg4];
    }
    
    if (arg3) {
        return [NSString stringWithFormat:format, arg1, arg2, arg3];
    }
    
    if (arg2) {
        return [NSString stringWithFormat:format, arg1, arg2];
    }
    
    if (arg1) {
        return [NSString stringWithFormat:format, arg1];
    }
    
    return format;
}

#pragma mark > Output to File

+ (BOOL)dumpString:(NSString *)string outputToFileName:(nullable NSString *)fileName {
    if (![string isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (fileName && ![fileName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *filePath;
    NSString *userHomeFileName = fileName.length ? fileName : [NSString stringWithFormat:@"lldb_output_%f.txt", [[NSDate date] timeIntervalSince1970]];
    
#if TARGET_OS_SIMULATOR
    NSString *appHomeDirectoryPath = [@"~" stringByExpandingTildeInPath];
    NSArray *pathParts = [appHomeDirectoryPath componentsSeparatedByString:@"/"];
    if (pathParts.count < 2) {
        return NO;
    }
    
    NSMutableArray *components = [NSMutableArray arrayWithObject:@"/"];
    // Note: pathParts is @"", @"Users", @"<your name>", ...
    [components addObjectsFromArray:[pathParts subarrayWithRange:NSMakeRange(1, 2)]];
    [components addObject:userHomeFileName];
    
    filePath = [NSString pathWithComponents:components];
#else
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:userHomeFileName];
#endif
    
    BOOL success = [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return success;
}

#pragma mark > Read String from File

+ (nullable NSString *)stringWithInputFileName:(nullable NSString *)fileName {
    if (fileName && ![fileName isKindOfClass:[NSString class]]) {
        return nil;
    }
        
    NSString *filePath;
    NSString *userHomeFileName = fileName.length ? fileName : @"lldb_input.txt";
        
#if TARGET_OS_SIMULATOR
    NSString *appHomeDirectoryPath = [@"~" stringByExpandingTildeInPath];
    NSArray *pathParts = [appHomeDirectoryPath componentsSeparatedByString:@"/"];
    if (pathParts.count < 2) {
        return nil;
    }
    
    NSMutableArray *components = [NSMutableArray arrayWithObject:@"/"];
    // Note: pathParts is @"", @"Users", @"<your name>", ...
    [components addObjectsFromArray:[pathParts subarrayWithRange:NSMakeRange(1, 2)]];
    [components addObject:userHomeFileName];
    
    filePath = [NSString pathWithComponents:components];
#else
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:userHomeFileName];
#endif
        
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return string;
}

#pragma mark - Color

#pragma mark > UIColor to NSString

+ (nullable NSString *)RGBAHexStringFromUIColor:(UIColor *)color {
    if (![color isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    CGFloat r, g, b, a;
    [self componentsOfRed:&r green:&g blue:&b alpha:&a fromColor:color];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)
            ];
}

+ (nullable NSString *)RGBHexStringFromUIColor:(UIColor *)color {
    if (![color isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    CGFloat r, g, b, a;
    [self componentsOfRed:&r green:&g blue:&b alpha:&a fromColor:color];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)
            ];
}

#pragma mark > NSString to UIColor

+ (nullable UIColor *)colorWithHexString:(NSString *)string {
    return [self colorWithHexString:string prefix:@"#"];
}

+ (nullable UIColor *)colorWithHexString:(NSString *)string prefix:(nullable NSString *)prefix {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Note: prefix is not nil, but not a NSString
    if (prefix && ![prefix isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // Note: prefix is nil, expect string length is 6 or 8
    if (!prefix && (string.length != 6 && string.length != 8)) {
        return nil;
    }
    
    if (prefix == nil) {
        prefix = @"";
    }
    
    if ([prefix rangeOfString:@"%"].location != NSNotFound) {
        return nil;
    }
    
    if ([string hasPrefix:prefix] && (string.length != (6 + prefix.length) && string.length != (8 + prefix.length))) {
        return nil;
    }
    
    // Note: -1 as failure flag
    int r = -1, g = -1, b = -1, a = -1;
    
    if (string.length == (6 + prefix.length)) {
        a = 0xFF;
        NSString *formatString = [NSString stringWithFormat:@"%@%%02x%%02x%%02x", prefix];
        sscanf([string UTF8String], [formatString UTF8String], &r, &g, &b);
    }
    else if (string.length == (8 + prefix.length)) {
        NSString *formatString = [NSString stringWithFormat:@"%@%%02x%%02x%%02x%%02x", prefix];
        sscanf([string UTF8String], [formatString UTF8String], &r, &g, &b, &a);
    }
    
    if (r == -1 || g == -1 || b == -1 || a == -1) {
        // parse hex failed
        return nil;
    }
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];
}

#pragma mark ::

+ (void)componentsOfRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha fromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    
    if (colorSpaceModel == kCGColorSpaceModelRGB && CGColorGetNumberOfComponents(color.CGColor) == 4) {
        *red = components[0];
        *green = components[1];
        *blue = components[2];
        *alpha = components[3];
    }
    else if (colorSpaceModel == kCGColorSpaceModelMonochrome && CGColorGetNumberOfComponents(color.CGColor) == 2) {
        *red = *green = *blue = components[0];
        *alpha = components[1];
    }
    else {
        *red = *green = *blue = *alpha = 0;
    }
}

#pragma mark ::

#pragma mark - Array

#pragma mark > Filter

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString {
    return [self filterArray:array usingPredicateString:predicateString arg1:nil arg2:nil arg3:nil arg4:nil arg5:nil];
}

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 {
    return [self filterArray:array usingPredicateString:predicateString arg1:arg1 arg2:nil arg3:nil arg4:nil arg5:nil];
}

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 {
    return [self filterArray:array usingPredicateString:predicateString arg1:arg1 arg2:arg2 arg3:nil arg4:nil arg5:nil];
}

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 {
    return [self filterArray:array usingPredicateString:predicateString arg1:arg1 arg2:arg2 arg3:arg3 arg4:nil arg5:nil];
}

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 {
    return [self filterArray:array usingPredicateString:predicateString arg1:arg1 arg2:arg2 arg3:arg3 arg4:arg4 arg5:nil];
}

+ (nullable NSArray *)filterArray:(NSArray *)array usingPredicateString:(NSString *)predicateString arg1:(nullable id)arg1 arg2:(nullable id)arg2 arg3:(nullable id)arg3 arg4:(nullable id)arg4 arg5:(nullable id)arg5 {
    
    if (![array isKindOfClass:[NSArray class]] || ![predicateString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (array.count == 0) {
        return array;
    }
    
    if (arg5) {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString, arg1, arg2, arg3, arg4, arg5]];
    }
    
    if (arg4) {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString, arg1, arg2, arg3, arg4]];
    }
    
    if (arg3) {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString, arg1, arg2, arg3]];
    }
    
    if (arg2) {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString, arg1, arg2]];
    }
    
    if (arg1) {
        return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString, arg1]];
    }
    
    NSArray *filteredArray;
    @try {
        filteredArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:predicateString]];
    }
    @catch (NSException *exception) {
    }
    
    return filteredArray;
}

#pragma mark > Output to File

+ (BOOL)iterateArray:(NSArray *)array keyPath:(NSString *)keyPath outputToFileName:(nullable NSString *)fileName {
    if (![array isKindOfClass:[NSArray class]] || ![keyPath isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (fileName && ![fileName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSMutableString *outputM = [NSMutableString string];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value;
        @try {
            value = [keyPath rangeOfString:@"."].location == NSNotFound ? [obj valueForKey:keyPath] : [obj valueForKeyPath:keyPath];
        }
        @catch (NSException *exception) {
            value = @"(exception)";
        }
        
        [outputM appendFormat:@"%@", value];
        [outputM appendString:@"\n----------------------\n"];
    }];
    
    NSString *filePath;
    NSString *userHomeFileName = fileName.length ? fileName : [NSString stringWithFormat:@"lldb_output_%f.txt", [[NSDate date] timeIntervalSince1970]];
    
#if TARGET_OS_SIMULATOR
    NSString *appHomeDirectoryPath = [@"~" stringByExpandingTildeInPath];
    NSArray *pathParts = [appHomeDirectoryPath componentsSeparatedByString:@"/"];
    if (pathParts.count < 2) {
        return NO;
    }
    
    NSMutableArray *components = [NSMutableArray arrayWithObject:@"/"];
    // Note: pathParts is @"", @"Users", @"<your name>", ...
    [components addObjectsFromArray:[pathParts subarrayWithRange:NSMakeRange(1, 2)]];
    [components addObject:userHomeFileName];
    
    filePath = [NSString pathWithComponents:components];
#else
    filePath = [NSHomeDirectory() stringByAppendingPathComponent:userHomeFileName];
#endif
    
    BOOL success = [outputM writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return success;
}

@end
