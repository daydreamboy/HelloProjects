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
    NSString *userHomeFileName = fileName ?: [NSString stringWithFormat:@"lldb_output_%f.txt", [[NSDate date] timeIntervalSince1970]];
    
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
