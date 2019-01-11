//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])

@implementation WCJSONTool

#pragma mark - Object to String

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options {
    return [self JSONStringWithObject:object printOptions:options filterInvalidObjects:NO];
}

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options filterInvalidObjects:(BOOL)filterInvalidObjects {
    if (![object isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    id rootObject = object;
    if ([rootObject isKindOfClass:[NSString class]]) {
        return (NSString *)rootObject;
    }
    else if ([rootObject isKindOfClass:[NSNumber class]] || [rootObject isKindOfClass:[NSNull class]]) {
        NSData *jsonData = nil;
        NSError *error = nil;
        @try {
            // @see https://stackoverflow.com/a/34268973
            // convert to array for distinguish @1/@YES, @0/@NO
            jsonData = [NSJSONSerialization dataWithJSONObject:@[rootObject] options:options error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
        }
        
        NSString *jsonString = nil;
        if (jsonData && !error) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            // Note: remove [] to get the only one element
            jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
        }
        
        return jsonString;
    }
    else if ([rootObject isKindOfClass:[NSArray class]] || [rootObject isKindOfClass:[NSDictionary class]]) {
        if (filterInvalidObjects && ![NSJSONSerialization isValidJSONObject:rootObject]) {
            rootObject = [self safeJSONObjectWithObject:rootObject];
        }
        
        NSData *jsonData = nil;
        NSError *error = nil;
        @try {
            jsonData = [NSJSONSerialization dataWithJSONObject:rootObject options:options error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
        }
        
        NSString *jsonString = nil;
        if (jsonData && !error) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        return jsonString;
    }
    else {
        return nil;
    }
}

+ (nullable id)safeJSONObjectWithObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]] || object == [NSNull null]) {
        return object;
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (id element in (NSArray *)object) {
            id item = [self safeJSONObjectWithObject:element];
            if (item) {
                [arrM addObject:item];
            }
        }
        return arrM;
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:[NSString class]]) {
                id value = [self safeJSONObjectWithObject:obj];
                if (value) {
                    dictM[key] = value;
                }
            }
        }];
        return dictM;
    }
    else {
        return nil;
    }
}

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSArray *)JSONArrayWithString:(NSString *)string {
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions objectClass:[NSArray class]];
}

+ (nullable NSDictionary *)JSONDictWithString:(NSString *)string {
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions objectClass:[NSDictionary class]];
}

#pragma mark > to NSMutableDictionary/NSMutableArray

+ (nullable NSMutableDictionary *)JSONMutableDictWithString:(NSString *)string {
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers objectClass:[NSMutableDictionary class]];
}

+ (nullable NSMutableArray *)JSONMutableArrayWithString:(NSString *)string {
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers objectClass:[NSMutableArray class]];
}

#pragma mark > to id

+ (nullable id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass {
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:options objectClass:objectClass];
}

#pragma mark - Data to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSDictionary *)JSONDictWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSDictionary class]];
}

+ (nullable NSArray *)JSONArrayWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSArray class]];
}

#pragma mark > to NSMutableDictionary/NSMutableArray

+ (nullable NSMutableDictionary *)JSONMutableDictWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:NSJSONReadingMutableContainers objectClass:[NSMutableDictionary class]];
}

+ (nullable NSMutableArray *)JSONMutableArrayWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:NSJSONReadingMutableContainers objectClass:[NSMutableArray class]];
}

#pragma mark > to id

+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    if (objectClass &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSArray class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableArray class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSDictionary class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableDictionary class])]
        ) {
        return nil;
    }
    
    @try {
        NSError *error;
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
        if (!JSONObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error);
        }
        
        if (objectClass == nil) {
            return JSONObject;
        }
        else {
            if ([JSONObject isKindOfClass:objectClass]) {
                return JSONObject;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass([self class]), exception);
    }
    
    return nil;
}

#pragma mark - JSON Escaped String

+ (nullable NSString *)JSONEscapedStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
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

#pragma mark - Assistant Methods

#pragma mark > Key Path Query

#pragma mark >> For JSON Object

+ (nullable NSArray *)arrayOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSArray class]];
}

+ (nullable NSDictionary *)dictionaryOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSDictionary class]];
}

+ (nullable NSString *)stringOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSString class]];
}

+ (NSInteger)integerOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    id obj = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:nil];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
    
    return NSNotFound;
}

+ (nullable NSNumber *)numberOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSNumber class]];
}

+ (BOOL)boolOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSNumber *number = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:nil];
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return [number boolValue];
}

+ (nullable NSNull *)nullOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSNull class]];
}

+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass {
    // An object that may be converted to JSON must have the following properties:
    // • The top level object is an NSArray or NSDictionary.
    // • All objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
    // • All dictionary keys are instances of NSString.
    // • Numbers are not NaN or infinity.
    // @sa https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/index.html#//apple_ref/occ/clm/NSJSONSerialization/isValidJSONObject:
    if (JSONObject && ![NSJSONSerialization isValidJSONObject:JSONObject]) {
        return nil;
    }
    
    return [self valueOfKVCObject:JSONObject usingKeyPath:keyPath objectClass:objectClass];
}

#pragma mark >> For KVC Object

+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass {
    return [self valueOfKVCObject:KVCObject usingKeyPath:keyPath bindings:nil objectClass:objectClass];
}

+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath bindings:(nullable NSDictionary *)bindings objectClass:(nullable Class)objectClass {
    if (!KVCObject || ![keyPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (keyPath.length == 0) {
        return KVCObject;
    }
    
    NSArray *parts = [keyPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id value = KVCObject;
    while (keys.count) {
        NSString *key = [keys firstObject];;
        
        if (bindings && [key rangeOfString:@"$"].location != NSNotFound) {
            key = [WCJSONTool stringByReplacingMatchesInString:key pattern:@"\\$(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))" captureGroupBindingBlock:^NSString *(NSString *matchString, NSArray<NSString *> *captureGroupStrings) {
                for (NSString *captureGroupString in captureGroupStrings) {
                    if (bindings[captureGroupString]) {
                        //NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                        return bindings[captureGroupString];
                    }
                }
                return nil;
            }];
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSArray", key);
                return nil;
            }
            
            NSInteger subscript = [key integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (subscript < 0 || subscript >= arr.count) {
                NSLog(@"Error: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            value = dict[key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            // Note: handle custom container
            NSObject *KVCObject = (NSObject *)value;
            @try {
                value = [KVCObject valueForKey:key];
            }
            @catch (NSException *e) {
                NSLog(@"Error: object %@ is not KVC compliant for key `%@`", KVCObject, key);
                return nil;
            }
        }
        else {
            NSLog(@"Error: unsupported object %@", KVCObject);
            return nil;
        }
        
        [keys removeObjectAtIndex:0];
    }
    
    return (objectClass == nil || [value isKindOfClass:objectClass]) ? value : nil;
}

#pragma mark >> For NSArray/NSDictionary

+ (nullable id)valueOfCollectionObject:(id)collectionObject usingBracketsPath:(NSString *)bracketsPath objectClass:(nullable Class)objectClass {
    if (![bracketsPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (!collectionObject || !([collectionObject isKindOfClass:[NSArray class]] || [collectionObject isKindOfClass:[NSDictionary class]])) {
        return nil;
    }
    
    if (bracketsPath.length == 0) {
        return collectionObject;
    }
    
    if (![NSPREDICATE(@"(\\[.+\\])+") evaluateWithObject:bracketsPath]) {
        return nil;
    }
    
    NSArray *parts = [bracketsPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id value = collectionObject;
    while (keys.count) {
        NSString *key = [keys firstObject];;
        
        if ([value isKindOfClass:[NSArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSArray", key);
                return nil;
            }
            
            NSInteger subscript = [key integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (subscript < 0 || subscript >= arr.count) {
                NSLog(@"Error: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            if (![NSPREDICATE(@"'.+'") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSDictionary, and must be quoted by `'`", key);
                return nil;
            }
            
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            NSString *subscript = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
            value = dict[subscript];
        }
        else {
            NSLog(@"Error: get value failed from object %@", collectionObject);
            return nil;
        }
        
        [keys removeObjectAtIndex:0];
    }
    
    return (objectClass == nil || [value isKindOfClass:objectClass]) ? value : nil;
}

#pragma mark > Print JSON string

+ (void)printJSONStringFromJSONObject:(id)JSONObject {
    NSString *JSONString = [self JSONStringWithObject:JSONObject printOptions:NSJSONWritingPrettyPrinted filterInvalidObjects:YES];
    NSLog(@"\n%@\n", JSONString);
}

#pragma mark > Objective-C literal string

+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered {
    return [self literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:YES];
}

+ (void)printLiteralStringFromJSONObject:(id)JSONObject {
    NSString *literalString = [self literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    NSLog(@"\n%@\n", literalString);
}

#pragma mark ::

+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject indentLevel:(NSUInteger)indentLevel startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered isRootContainer:(BOOL)isRootContainer {
    
    if ([JSONObject isKindOfClass:[NSNumber class]]) {
        if ([WCJSONTool checkNumberAsBooleanWithNumber:JSONObject]) {
            return [NSString stringWithFormat:@"%@", [(NSNumber *)JSONObject boolValue] ? @"@YES": @"@NO"];
        }
        else {
            return [NSString stringWithFormat:@"@(%@)", [(NSNumber *)JSONObject stringValue]];
        }
    }
    else if ([JSONObject isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"@\"%@\"", JSONObject];
    }
    else if ([JSONObject isKindOfClass:[NSNull class]]) {
        return @"[NSNull null]";
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]] || [JSONObject isKindOfClass:[NSArray class]]) {
        // @see https://stackoverflow.com/a/4608137
        NSString *indentSpaceForContainer = [@"" stringByPaddingToLength:indentLevel * indentLength + startIndentLength withString:@" " startingAtIndex:0];
        NSString *indentSpaceForElement = [@"" stringByPaddingToLength:(indentLevel + 1) * indentLength + startIndentLength withString:@" " startingAtIndex:0];
        
        NSMutableString *stringM = [NSMutableString stringWithCapacity:1000];
        if (isRootContainer) {
            [stringM appendString:[@"" stringByPaddingToLength:startIndentLength withString:@" " startingAtIndex:0]];
        }
        __block BOOL isFirstElement = YES;
        
        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            // @see https://stackoverflow.com/a/2556306
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSString class]];
            NSArray *filteredKeys = [[(NSDictionary *)JSONObject allKeys] filteredArrayUsingPredicate:predicate];
            NSArray *keys = ordered ? ([filteredKeys sortedArrayUsingSelector:@selector(compare:)]) : filteredKeys;
            
            [stringM appendString:@"@{\n"];
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([key isKindOfClass:[NSString class]]) {
                    id value = [(NSDictionary *)JSONObject objectForKey:key];
                    NSString *literalString = [self literalStringWithJSONObject:value indentLevel:indentLevel + 1 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:NO];
                    if (literalString) {
                        if (!isFirstElement) {
                            [stringM appendString:@",\n"];
                        }
                        [stringM appendFormat:@"%@@\"%@\" : %@", indentSpaceForElement, key, literalString];
                        isFirstElement = NO;
                    }
                }
            }];
            [stringM appendFormat:@"\n%@}", indentSpaceForContainer];
        }
        else {
            [stringM appendString:@"@[\n"];
            [(NSArray *)JSONObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *literalString = [self literalStringWithJSONObject:obj indentLevel:indentLevel + 1 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:NO];
                if (literalString) {
                    if (!isFirstElement) {
                        [stringM appendString:@",\n"];
                    }
                    [stringM appendFormat:@"%@%@", indentSpaceForElement, literalString];
                    isFirstElement = NO;
                }
            }];
            [stringM appendFormat:@"\n%@]", indentSpaceForContainer];
        }
        
        return stringM;
    }
    else {
        return nil;
    }
}

#pragma mark ::

#pragma mark - Utility Methods

+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string pattern:(NSString *)pattern captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock {
    
    if (!captureGroupBindingBlock) {
        return string;
    }
    
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    NSMutableArray<NSString *> *replacementStrings = [NSMutableArray array];
    BOOL status = [self enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange matchRange = result.range;
        if (matchRange.location != NSNotFound && matchRange.length > 0) {
            NSString *matchString = [WCJSONTool substringWithString:string range:matchRange];
            
            NSMutableArray *captureGroupStrings = [NSMutableArray array];
            for (NSInteger i = 1; i < result.numberOfRanges; i++) {
                NSRange captureRange = [result rangeAtIndex:i];
                if (captureRange.location != NSNotFound) {
                    NSString *captureGroupString = [WCJSONTool substringWithString:string range:captureRange];
                    [captureGroupStrings addObject:captureGroupString ?: @""];
                }
                else {
                    [captureGroupStrings addObject:@""];
                }
            }
            
            NSString *replacementString = captureGroupBindingBlock(matchString, captureGroupStrings);
            if (replacementString) {
                [ranges addObject:[NSValue valueWithRange:matchRange]];
                [replacementStrings addObject:replacementString];
            }
        }
    }];
    
    if (!status) {
        return string;
    }
    
    return [WCJSONTool replaceCharactersInRangesWithString:string ranges:ranges replacementStrings:replacementStrings replacementRanges:nil];
}

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return NO;
    }
    
    if (block) {
        // Note: string should not nil
        [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            BOOL shouldStop = NO;
            block(result, flags, &shouldStop);
            *stop = shouldStop;
        }];
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= string.length) {
        // Note: Don't use range.location + range.length <= string.length, because if length is too large (e.g. NSUIntegerMax), location + length will become smaller (upper overflow)
        if (range.length <= string.length - range.location) {
            return [string substringWithRange:range];
        }
        else {
            return nil;;
        }
    }
    else {
        return nil;
    }
}

+ (nullable NSString *)replaceCharactersInRangesWithString:(NSString *)string ranges:(NSArray<NSValue *> *)ranges replacementStrings:(NSArray<NSString *> *)replacementStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges {
    
    if (![string isKindOfClass:[NSString class]] ||
        ![ranges isKindOfClass:[NSArray class]] ||
        ![replacementStrings isKindOfClass:[NSArray class]] ||
        ranges.count != replacementStrings.count) {
        return nil;
    }
    
    // Parameter check: replacementRanges
    if (replacementRanges && ![replacementRanges isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    // Parameter check: replacementStrings
    for (NSString *element in replacementStrings) {
        if (![element isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    
    // Parameter check: ranges
    for (NSValue *value in ranges) {
        if (![value isKindOfClass:[NSValue class]]) {
            return nil;
        }
        
        NSRange range = [value rangeValue];
        if (range.location == NSNotFound || range.length == 0) {
            return nil;
        }
        
        if (!NSRangeContainsRange(NSMakeRange(0, string.length), range)) {
            return nil;
        }
    }
    
    // Note: empty array just return the original string
    if (ranges.count == 0 && replacementStrings.count == 0) {
        return string;
    }
    
    // Note: sort the ranges by ascend
    NSArray *sortedRanges = [ranges sortedArrayUsingComparator:^NSComparisonResult(NSValue * _Nonnull value1, NSValue * _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.rangeValue.location > value2.rangeValue.location) {
            result = NSOrderedDescending;
        }
        else if (value1.rangeValue.location < value2.rangeValue.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    NSRange previousRange = NSMakeRange(0, 0);
    for (NSInteger i = 0; i < sortedRanges.count; i++) {
        NSRange currentRange = [sortedRanges[i] rangeValue];
        // @see https://stackoverflow.com/a/10172768
        NSRange intersection = NSIntersectionRange(previousRange, currentRange);
        if (intersection.length > 0) {
            // Note: the two ranges does intersect
            return nil;
        }
        
        previousRange = currentRange;
    }
    
    NSInteger (^checkChacterInRanges)(NSRange) = ^NSInteger(NSRange rangeOfCharacter) {
        for (NSInteger i = 0; i < sortedRanges.count; i++) {
            NSRange currentRange = [sortedRanges[i] rangeValue];
            if (NSRangeContainsRange(currentRange, rangeOfCharacter)) {
                return i;
            }
        }
        
        return NSNotFound;
    };
    
    NSMutableArray<id> *replacementStringsM = [replacementStrings mutableCopy];
    [replacementRanges removeAllObjects];
    for (NSInteger i = 0; i < replacementStringsM.count; i++) {
        replacementRanges[i] = [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)];
    }
    
    NSMutableString *stringM = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        NSRange rangeOfCharacter = substringRange;
        
        NSInteger index = checkChacterInRanges(rangeOfCharacter);
        if (index != NSNotFound) {
            NSValue *rangeValue = sortedRanges[index];
            
            // Note: find the index of the replacement string in unsorted array
            NSInteger indexOfReplacementString = [ranges indexOfObject:rangeValue];
            if (indexOfReplacementString != NSNotFound) {
                NSString *stringToInsert = replacementStringsM[indexOfReplacementString];
                
                // Note: allow to insert empty string and check it if [NSNull null]
                if (stringToInsert && [stringToInsert isKindOfClass:[NSString class]]) {
                    // Note: record the range of stringToInsert
                    NSRange replacementRange = NSMakeRange(stringM.length, stringToInsert.length);
                    replacementRanges[indexOfReplacementString] = [NSValue valueWithRange:replacementRange];
                    
                    [stringM appendString:stringToInsert];
                    
                    // Note: set the stringToInsert to [NSNull null] to avoid inserting again
                    replacementStringsM[indexOfReplacementString] = [NSNull null];
                }
            }
        }
        else {
            [stringM appendString:character];
        }
    }];
    
    return stringM;
}

+ (BOOL)checkNumberAsBooleanWithNumber:(NSNumber *)number {
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    CFTypeID boolID = CFBooleanGetTypeID(); // the type ID of CFBoolean
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(number)); // the type ID of num
    return numID == boolID;
}

#pragma mark - Private Utility Functions

/**
 Check if NSRange contains the other NSRange

 @param range1 the range which is expected as super range
 @param range2 the range which is expected as sub range
 @return YES if range1 contains or equals range2, and otherwise NO.
 @see https://gist.github.com/wokalski/3130403
 */
static BOOL NSRangeContainsRange(NSRange range1, NSRange range2) {
    BOOL retval = NO;
    if (range1.location <= range2.location && range1.location + range1.length >= range2.length + range2.location) {
        retval = YES;;
    }
    
    return retval;
}

@end
