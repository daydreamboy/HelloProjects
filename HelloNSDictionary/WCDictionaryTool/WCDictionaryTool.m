//
//  WCDictionaryTool.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/6/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDictionaryTool.h"

@implementation WCDictionaryTool

#pragma mark - Safe access values (NSArray, NSDictionary, NSString, NSNumber) for key/keypath

+ (id)dictionary:(NSDictionary *)dictionary objectForKey:(NSString *)key objectClass:(Class)objectClass {
    // key is not a NSString
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    // dictionary is not NSDictionary
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
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

+ (NSArray *)dictionary:(NSDictionary *)dictionary arrayForKey:(NSString *)key {
    return [self dictionary:dictionary objectForKey:key objectClass:[NSArray class]];
}

+ (NSDictionary *)dictionary:(NSDictionary *)dictionary dictForKey:(NSString *)key {
    return [self dictionary:dictionary objectForKey:key objectClass:[NSDictionary class]];
}

+ (NSString *)dictionary:(NSDictionary *)dictionary stringForKey:(NSString *)key {
    return [self dictionary:dictionary objectForKey:key objectClass:[NSString class]];
}

+ (NSNumber *)dictionary:(NSDictionary *)dictionary numberForKey:(NSString *)key {
    return [self dictionary:dictionary objectForKey:key objectClass:[NSNumber class]];
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

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString {
    if (![jsonString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return nil;
    }
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (![NSJSONSerialization isValidJSONObject:dict]) {
        return nil;
    }
    
    return dict;
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
