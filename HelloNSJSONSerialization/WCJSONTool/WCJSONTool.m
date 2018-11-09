//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

@implementation WCJSONTool

#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])

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

/**
 Convert the JSON formatted string to NSArray or NSDictionary object
 
 @param string the JSON formatted string
 @return If the string is not JSON formatted, return nil.
 */
+ (nullable id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)options objectClass:(Class)objectClass {
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

+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(Class)objectClass {
    if (![data isKindOfClass:[NSData class]] && (
        [NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSArray class])] ||
        [NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableArray class])] ||
        [NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSDictionary class])] ||
        [NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableDictionary class])])
        ) {
        return nil;
    }
    
    @try {
        NSError *error;
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
        if (!JSONObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error);
        }
        
        if ([JSONObject isKindOfClass:objectClass]) {
            return JSONObject;
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

+ (nullable NSArray *)arrayOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSArray *arr = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    return [arr isKindOfClass:[NSArray class]] ? arr : nil;
}

+ (nullable NSDictionary *)dictionaryOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSDictionary *dict = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    return [dict isKindOfClass:[NSDictionary class]] ? dict : nil;
}

+ (nullable NSString *)stringOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSString *str = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    return [str isKindOfClass:[NSString class]] ? str : nil;
}

+ (NSInteger)integerOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    id obj = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
    
    return NSNotFound;
}

+ (nullable NSNumber *)numberOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSNumber *number = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    return [number isKindOfClass:[NSNumber class]] ? number : nil;
}

+ (BOOL)boolOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSNumber *number = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return [number boolValue];
}

+ (nullable NSNull *)nullOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSNull *null = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath];
    return [null isKindOfClass:[NSNull class]] ? null : nil;
}

+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    if (!JSONObject || ![keyPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (keyPath.length == 0) {
        return JSONObject;
    }
    
    // An object that may be converted to JSON must have the following properties:
    // • The top level object is an NSArray or NSDictionary.
    // • All objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
    // • All dictionary keys are instances of NSString.
    // • Numbers are not NaN or infinity.
    // @sa https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/index.html#//apple_ref/occ/clm/NSJSONSerialization/isValidJSONObject:
    if (![NSJSONSerialization isValidJSONObject:JSONObject]) {
        return nil;
    }
    
    NSArray *parts = [keyPath componentsSeparatedByString:@"."];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    
    id value = JSONObject;
    while (keys.count) {
        NSString *key = [keys firstObject];
        
        if ([key hasPrefix:@"["] && [key hasSuffix:@"]"]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"^\\[(0|[1-9]\\d*)\\]$") evaluateWithObject:key]) {
#if DEBUG
                NSString *reason = [NSString stringWithFormat:@"%@ is not a subscript of NSArray", key];
                @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
#endif
                return nil;
            }
            
            NSUInteger subscript = [[key substringWithRange:NSMakeRange(1, key.length - 2)] integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (![arr isKindOfClass:[NSArray class]]) {
                NSLog(@"Warning: Expected a NSArray but not %@", arr);
                return nil;
            }
            
            if (subscript >= arr.count) {
                NSLog(@"Warning: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else {
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            if (![dict isKindOfClass:[NSDictionary class]]) {
                NSLog(@"Warning: Expected a NSDictionary but not %@", dict);
                return nil;
            }
            
            value = dict[key];
        }
        [keys removeObject:key];
    }
    
    return value;
}

@end
