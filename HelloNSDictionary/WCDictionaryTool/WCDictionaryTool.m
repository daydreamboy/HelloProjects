//
//  WCDictionaryTool.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/6/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDictionaryTool.h"

@implementation WCDictionaryTool

#pragma mark - Get Value for Key

#pragma mark > keypath

+ (nullable NSArray *)arrayWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    return [self objectWithDictionary:dictionary forKey:key objectClass:[NSArray class]];
}

+ (nullable NSDictionary *)dictWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    return [self objectWithDictionary:dictionary forKey:key objectClass:[NSDictionary class]];
}

+ (nullable NSString *)stringWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    return [self objectWithDictionary:dictionary forKey:key objectClass:[NSString class]];
}

+ (nullable NSNumber *)numberWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    return [self objectWithDictionary:dictionary forKey:key objectClass:[NSNumber class]];
}

+ (nullable id)objectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key objectClass:(Class)objectClass {
    if (![key isKindOfClass:[NSString class]] || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSArray class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSDictionary class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSString class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSNumber class])]) {
        return nil;
    }
    
    id object;
    
    if ([key rangeOfString:@"."].location == NSNotFound) {
        object = dictionary[key];
    }
    else {
        object = [dictionary valueForKeyPath:key];
    }
    
    return [object isKindOfClass:objectClass] ? object : nil;
}

#pragma mark - Safe Wrapping

#ifndef __FILE_NAME__
#define __FILE_NAME__ ((strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1)
#endif

+ (NSDictionary *)dictionaryWithKeyAndValues:(id)firstKey, ... NS_REQUIRES_NIL_TERMINATION {
    NSDictionary *dict;
    id eachKey;
    id eachValue;
    va_list argumentList;
    
    if (firstKey) { // The first argument isn't part of the varargs list,
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        
        va_start(argumentList, firstKey); // Start scanning for arguments after firstObject.
        @try {
            eachKey = firstKey;
            while (eachKey && (eachValue = va_arg(argumentList, id))) { // As many times as we can get an argument of type "id"
                [dictM setValue:eachValue forKey:eachKey];
                eachKey = va_arg(argumentList, id);
            }
        }
        @catch (NSException *exception) {
#if DISABLE_THROW_EXCEPTION
            NSLog(@"[Error][%s, line: %d] %@", __FILE_NAME__, __LINE__, exception);
#else
            [exception raise];
#endif
        }
        
        va_end(argumentList);
        
        if (eachKey && !eachValue) {
            NSString *reason = [NSString stringWithFormat:@"key & value is not paired, value for key `%@` should not be nil", eachKey];
            NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
            
#if DISABLE_THROW_EXCEPTION
            NSLog(@"[Error][%s, line: %d] %@", __FILE_NAME__, __LINE__, exception);
#else
            [exception raise];
#endif
        }
        
        if (dictM.count) {
            dict = [dictM copy];
        }
    }
    
    return dict;
}

#pragma mark - Modification

+ (nullable NSDictionary *)removeObjectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key {
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictM addEntriesFromDictionary:dictionary];
    [dictM removeObjectForKey:key];
        
    return dictM;
}

#pragma mark - Override Methods

+ (NSString *)debugDescriptionWithDictionary:(NSDictionary *)dictionary {
    NSMutableString *stringM = [NSMutableString stringWithString:@"{\n"];
    
    for (id key in [dictionary allKeys]) {
        id value = dictionary[key];
        [stringM appendFormat:@"\t%@ : %@\n", key, value];
    }
    [stringM appendString:@"}\n"];
    
    return stringM;
}

@end
