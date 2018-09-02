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
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = nil;
        @try {
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:object options:options error:&error];
        }
        @catch (NSException *exception) {
            if (![NSJSONSerialization isValidJSONObject:object]) {
                NSLog(@"[%@]: %@ is not a valid JSON object", NSStringFromClass(self), object);
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
    else if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSNull class]]) {
        NSData *jsonData = nil;
        @try {
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:object options:options error:&error];
        }
        @catch (NSException *exception) {
            if (![NSJSONSerialization isValidJSONObject:object]) {
                NSLog(@"[%@]: %@ is not a valid JSON object", NSStringFromClass(self), object);
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
    else if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    else {
        return nil;
    }
}

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options tolerateInvalidObjects:(BOOL)tolerateInvalidObjects NS_AVAILABLE_IOS(5_0) {
    if (!tolerateInvalidObjects) {
        return [self JSONStringWithObject:object printOptions:options];
    }
    else {
        // TODO:
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
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSMutableDictionary class]];
}

+ (nullable NSMutableArray *)JSONMutableArrayWithData:(NSData *)data {
    return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSMutableArray class]];
}

#pragma mark > to id

+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(Class)objectClass {
    if (![data isKindOfClass:[NSData class]] ||
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSArray class])] ||
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableArray class])] ||
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSDictionary class])] ||
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
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

@end
