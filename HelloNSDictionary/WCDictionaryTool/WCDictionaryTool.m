//
//  WCDictionaryTool.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/6/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDictionaryTool.h"

#define NSPREDICATE(expression)   ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])

#ifndef __FILE_NAME__
#define __FILE_NAME__ ((strrchr(__FILE__, '/') ?: __FILE__ - 1) + 1)
#endif

@implementation WCDictionaryTool

#pragma mark - Get Value for Key

#pragma mark > keypath

+ (nullable NSArray *)arrayWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath {
    return [self objectWithDictionary:dictionary forKeyPath:keyPath objectClass:[NSArray class]];
}

+ (nullable NSDictionary *)dictWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath {
    return [self objectWithDictionary:dictionary forKeyPath:keyPath objectClass:[NSDictionary class]];
}

+ (nullable NSString *)stringWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath {
    return [self objectWithDictionary:dictionary forKeyPath:keyPath objectClass:[NSString class]];
}

+ (nullable NSNumber *)numberWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath {
    return [self objectWithDictionary:dictionary forKeyPath:keyPath objectClass:[NSNumber class]];
}

+ (nullable id)objectWithDictionary:(NSDictionary *)dictionary forKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass {
    if (![keyPath isKindOfClass:[NSString class]] || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (keyPath.length == 0) {
        return dictionary;
    }
    
    id object = nil;
    
    @try {
        if ([keyPath containsString:@"."]) {
            object = [dictionary valueForKeyPath:keyPath];
        }
        else {
            object = [dictionary valueForKey:keyPath];
        }
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"an exception occurred: %@", exception);
#endif
    }
    
    return (objectClass == nil || [object isKindOfClass:objectClass]) ? object : nil;
}

+ (nullable NSDictionary<NSString *, id> *)flattenDictionaryWithDictionary:(NSDictionary *)dictionary option:(WCFlattenDictionaryOption)option {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    __block NSMutableDictionary *flattenDictM = [NSMutableDictionary dictionary];
    
    BOOL (^checkIsContainer)(id) = ^BOOL(id container) {
        BOOL isContainer = NO;
        
        if ((option == WCFlattenDictionaryOptionOnlyDictionary) && [container isKindOfClass:[NSDictionary class]]) {
            isContainer = YES;
        }
        else if ((option == WCFlattenDictionaryOptionOnlyDictionaryAndArray) &&
                 ([container isKindOfClass:[NSDictionary class]] || [container isKindOfClass:[NSArray class]])) {
            isContainer = YES;
        }
        
        return isContainer;
    };
    
    // @see https://stackoverflow.com/a/19905407
    __block __weak void (^weak_block)(NSString *, id);
    __block __strong void (^block)(NSString *, id);
    
    weak_block = block = ^(NSString *currentPath, id container) {
        if ([container isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)container;
            
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                NSString *keyPath = currentPath.length ? [[currentPath stringByAppendingString:@"."] stringByAppendingString:key] : [key copy];
                
                if (checkIsContainer(obj)) {
                    weak_block(keyPath, obj);
                }
                else {
                    flattenDictM[keyPath] = obj;
                }
            }];
        }
        else if ([container isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)container;
            for (NSUInteger i = 0; i < arr.count; ++i) {
                NSString *index = [NSString stringWithFormat:@"[%lu]", (unsigned long)i];
                NSString *keyPath = currentPath.length ? [[currentPath stringByAppendingString:@"."] stringByAppendingString:index] : index;
             
                if (checkIsContainer(arr[i])) {
                    weak_block(keyPath, arr[i]);
                }
                else {
                    flattenDictM[keyPath] = arr[i];
                }
            }
        }
    };
    
    block(@"", dictionary);
    
    return [flattenDictM copy];
}

#pragma mark - Safe Wrapping

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

+ (nullable NSDictionary *)removeObjectWithDictionary:(NSDictionary *)dictionary forKey:(NSString *)key allowMutable:(BOOL)allowMutable {
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictM addEntriesFromDictionary:dictionary];
    [dictM removeObjectForKey:key];
        
    return allowMutable ? dictM : [dictM copy];
}

+ (nullable NSDictionary *)setObjectWithDictionary:(NSDictionary *)dictionary object:(nullable id)object forKey:(NSString *)key allowMutable:(BOOL)allowMutable {
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictM addEntriesFromDictionary:dictionary];
    dictM[key] = object;
    
    return allowMutable ? dictM : [dictM copy];
}

+ (nullable NSDictionary *)swappedKeyValueDictionaryWithDictionary:(NSDictionary *)dictionary allowMutable:(BOOL)allowMutable {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (dictionary.count == 0) {
        return allowMutable ? [NSMutableDictionary dictionary] : [NSDictionary dictionary];
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dictM[obj] = key;
    }];
    
    // Note: If the new keys not equal the old keys of dictionary, consider the swap is failed
    if ([dictM allKeys].count != [dictionary allKeys].count) {
        return nil;
    }
    
    return allowMutable ? dictM : [dictM copy];
}

#pragma mark - Conversion

+ (nullable NSDictionary<NSString *, id> *)transformDictionary:(NSDictionary<NSString *, id> *)dictionary usingKeysMapping:(NSDictionary<NSString *, NSString *> *)keysMapping mode:(WCKeysMappingMode)mode {
    
    if (![dictionary isKindOfClass:[NSDictionary class]] || ![keysMapping isKindOfClass:[NSDictionary class]] ||
        (mode != WCKeysMappingModeIgnoreKeysIfNotSet && mode != WCKeysMappingModeKeepKeysIfNotSet)) {
        return nil;
    }
    
    NSMutableDictionary *newMap = [NSMutableDictionary dictionaryWithCapacity:dictionary.count];
    
    if (mode == WCKeysMappingModeIgnoreKeysIfNotSet) {
        [keysMapping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull originalKey, NSString * _Nonnull newKey, BOOL * _Nonnull stop) {
            id value = nil;
            @try {
                if ([originalKey rangeOfString:@"."].location == NSNotFound) {
                    value = [dictionary valueForKey:originalKey];
                }
                else {
                    value = [dictionary valueForKeyPath:originalKey];
                }
            }
            @catch (NSException *e) {
                NSLog(@"an exception occurred: %@", e);
            }
            
            if (value) {
                if ([newKey rangeOfString:@"."].location == NSNotFound) {
                    newMap[newKey] = value;
                }
                else if ([NSPREDICATE(@"(\\w+|\\[\\w+\\])(\\.(\\w+|\\[\\w+\\]))+") evaluateWithObject:newKey]) {
                    // @see https://stackoverflow.com/a/4739777
                    NSArray *components = [newKey componentsSeparatedByString:@"."];
                    
                    id currentContainer = newMap;
                    for (NSInteger i = 0; i < components.count; i++) {
                        NSString *pathComponent = components[i];
                        if (i == components.count - 1) {
                            if ([currentContainer isKindOfClass:[NSMutableDictionary class]]) {
                                currentContainer[pathComponent] = value;
                            }
                        }
                        else {
                            if ([pathComponent hasPrefix:@"["] && [pathComponent hasSuffix:@"]"]) {
                                
                            }
                            else {
                                
                            }
                            
                            if ([currentContainer isKindOfClass:[NSMutableDictionary class]]) {
                                if (![currentContainer objectForKey:pathComponent]) {
                                    currentContainer[pathComponent] = [NSMutableDictionary dictionary];
                                }
                                
                                currentContainer = currentContainer[pathComponent];
                            }
                            else if ([currentContainer isKindOfClass:[NSMutableArray class]]) {
                                
                            }
                            else {
                                
                            }
                        }
                    }
                }
            }
        }];
    }
    else if (mode == WCKeysMappingModeKeepKeysIfNotSet) {
        
    }
    
    return newMap;
}

#pragma mark - Two Dictionary Operation

#pragma mark > Merge

+ (nullable NSDictionary *)mergedDictionaryWithDictionary1:(nullable NSDictionary *)dictionary1 dictionary2:(nullable NSDictionary *)dictionary2 allowMutable:(BOOL)allowMutable {
    if (dictionary1 && ![dictionary1 isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (dictionary2 && ![dictionary2 isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    if (dictionary1) {
        [dictM addEntriesFromDictionary:dictionary1];
    }
    if (dictionary2) {
        [dictM addEntriesFromDictionary:dictionary2];
    }
    
    return allowMutable ? dictM : [dictM copy];
}

@end
