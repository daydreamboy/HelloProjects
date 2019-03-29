//
//  WCObjectTool.m
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCObjectTool.h"
#import <objc/runtime.h>

// 4 spaces for indentation
#define INDENTATION @"    "

@implementation WCObjectTool

#pragma mark - Inspection

#pragma mark > Dump

+ (void)dumpWithObject:(NSObject *)object {
    printf("%s\n", [[self dumpedStringWithObject:object] UTF8String]);
}

+ (nullable NSString *)dumpedStringWithObject:(NSObject *)object {
    if (![object isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    NSMutableString *stringM = [NSMutableString string];
    traverse_object(stringM, object, 0, NO);
    
    return [stringM copy];
}

#pragma mark ::

static void traverse_object(NSMutableString *stringM, id object, NSUInteger depth, BOOL isValueForKey) {
    
    if (isValueForKey) {
        // hanlde value if it has a counter-part key
        [stringM appendString:@" : "];
    }
    else {
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        
        [stringM appendString:@"{\n"];
        
        NSArray *allKeys = [[object allKeys] sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull key1, id _Nonnull key2) {
            if ([[key1 description] compare:[key2 description]] == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            else if ([[key1 description] compare:[key2 description]] == NSOrderedDescending) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        NSUInteger numberOfAllKeys = [allKeys count];
        for (NSUInteger i = 0; i < numberOfAllKeys; i++) {
            id key = allKeys[i];
            traverse_object(stringM, key, depth + 1, NO);
            
            id value = [object objectForKey:key];
            traverse_object(stringM, value, depth + 1, YES);
            
            // newline after one pair except last one
            [stringM appendString:(i != numberOfAllKeys - 1 ? @",\n" : @"")];
        }
        
        // revert the process of @"{"
        [stringM appendString:@"\n"];
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
        [stringM appendString:@"}"];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        [stringM appendString:@"[\n"];
        
        NSUInteger numberOfAllItems = [object count];
        for (NSUInteger i = 0; i < numberOfAllItems; i++) {
            id item = object[i];
            traverse_object(stringM, item, depth + 1, NO);
            
            // newline after one item except last one
            [stringM appendString:(i != numberOfAllItems - 1 ? @",\n" : @"")];
        }
        
        // revert the process of @"["
        [stringM appendString:@"\n"];
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
        [stringM appendString:@"]"];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        NSString *JSONEscapedString = JSONEscapedStringFromString((NSString *)object);
        [stringM appendFormat:@"\"%@\"", JSONEscapedString];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        
        // @sa http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        if (object == (void *)kCFBooleanTrue || object == (void *)kCFBooleanFalse) {
            // only convert @YES/@NO to true/false, not support @(true)/@(TRUE)
            BOOL isTrue = [object boolValue];
            [stringM appendString:(isTrue ? @"true" : @"false")];
        }
        else {
            [stringM appendFormat:@"%@", [object stringValue]];
        }
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        [stringM appendString:@"null"];
    }
    else {
        // call object's description method
        [stringM appendFormat:@"%@", object];
    }
}

// Convert NSString to JSON string
static NSString * JSONEscapedStringFromString(NSString *string) {
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    
    [stringM replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    
    return [NSString stringWithString:stringM];
}

#pragma mark ::

#pragma mark > Runtime

+ (NSArray<NSString *> *)allClasses {
    unsigned int classesCount;
    Class *classes = objc_copyClassList(&classesCount);
    NSMutableArray *result = [NSMutableArray array];
    for (unsigned int i = 0 ; i < classesCount; i++) {
        [result addObject:NSStringFromClass(classes[i])];
    }
    return [result sortedArrayUsingSelector:@selector(compare:)];
}

@end
