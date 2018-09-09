//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

@interface WCJSONTool ()
+ (NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options;
@end

@implementation NSArray (WCJSONTool)

- (NSString *)JSONString {
    return [WCJSONTool JSONStringWithObject:self printOptions:kNilOptions];
}

- (NSString *)JSONStringWithReadability {
    return [WCJSONTool JSONStringWithObject:self printOptions:NSJSONWritingPrettyPrinted];
}

@end

@implementation NSDictionary (WCJSONTool)

- (NSString *)JSONString {
    return [WCJSONTool JSONStringWithObject:self printOptions:kNilOptions];
}

- (NSString *)JSONStringWithReadability {
    return [WCJSONTool JSONStringWithObject:self printOptions:NSJSONWritingPrettyPrinted];
}

@end

@implementation WCJSONTool

#pragma mark - Object to String

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options NS_AVAILABLE_IOS(5_0) {
    return [self JSONStringWithObject:object printOptions:options filterInvalidObjects:NO];
}

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options filterInvalidObjects:(BOOL)filterInvalidObjects {
    id JSONObject = object;
    
    if (filterInvalidObjects && ![NSJSONSerialization isValidJSONObject:JSONObject]) {
        if (![JSONObject isKindOfClass:[NSArray class]] || ![JSONObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        if ([JSONObject isKindOfClass:[NSArray class]]) {
            NSMutableArray *container = [NSMutableArray array];
            // TODO:
            JSONObject = container;
        }
        else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *container = [NSMutableDictionary dictionary];
            // TODO:
            JSONObject = container;
        }
    }
    
    if ([JSONObject isKindOfClass:[NSArray class]] || [JSONObject isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = nil;
        @try {
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:JSONObject options:options error:&error];
        }
        @catch (NSException *exception) {
            if (![NSJSONSerialization isValidJSONObject:JSONObject]) {
                NSLog(@"[%@]: %@ is not a valid JSON object", NSStringFromClass(self), JSONObject);
            }
            else {
                NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
            }
        }
        
        NSString *jsonString = nil;
        if (jsonData) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        return jsonString;
    }
    else if ([JSONObject isKindOfClass:[NSNumber class]] || [JSONObject isKindOfClass:[NSNull class]]) {
        NSData *jsonData = nil;
        @try {
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:JSONObject options:options error:&error];
        }
        @catch (NSException *exception) {
            if (![NSJSONSerialization isValidJSONObject:JSONObject]) {
                NSLog(@"[%@]: %@ is not a valid JSON object", NSStringFromClass(self), JSONObject);
            }
            else {
                NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
            }
        }
        
        NSString *jsonString = nil;
        if (jsonData) {
            // @see https://stackoverflow.com/a/34268973
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
        }
        
        return jsonString;
    }
    else if ([JSONObject isKindOfClass:[NSString class]]) {
        return JSONObject;
    }
    else {
        return nil;
    }
}

- (void)duplicateDictionary:(NSDictionary *)dict toContainer:(NSMutableDictionary *)container {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                
            }
            else if ([value isKindOfClass:[NSArray class]]) {
                
            }
        }];
    }
}

- (void)processParsedObject:(id)object
{
    [self processParsedObject:object depth:0 parent:nil];
}

- (void)processParsedObject:(id)object depth:(int)depth parent:(id)parent
{
    if ([object isKindOfClass:[NSDictionary class]])
    {
        for (NSString* key in [object allKeys])
        {
            id child = [object objectForKey:key];
            [self processParsedObject:child depth:(depth + 1) parent:object];
        }
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        for (id child in object)
        {
            [self processParsedObject:child depth:(depth + 1) parent:object];
        }
    }
    else
    {
        // This object is not a container you might be interested in it's value
        NSLog(@"Node: %@  depth: %d", [object description], depth);
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
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSMutableDictionary class]];
}

+ (nullable NSMutableArray *)JSONMutableArrayWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSMutableArray class]];
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
