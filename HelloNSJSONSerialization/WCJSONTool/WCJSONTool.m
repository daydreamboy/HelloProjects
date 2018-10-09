//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

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
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
        if (!jsonObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error);
        }
        
        if ([jsonObject isKindOfClass:objectClass]) {
            return jsonObject;
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

@end
