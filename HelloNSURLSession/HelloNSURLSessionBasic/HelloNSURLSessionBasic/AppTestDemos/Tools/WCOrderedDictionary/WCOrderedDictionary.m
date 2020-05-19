//
//  WCOrderedDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCOrderedDictionary.h"

@implementation WCOrderedDictionary {
@private
    NSMutableArray *_orderedKeys;
    NSMutableDictionary *_storage;
}

#pragma mark - Getters

- (NSArray *)allKeys {
    return [_orderedKeys copy];
}

- (NSArray *)allValues {
    NSMutableArray *valuesM = [NSMutableArray arrayWithCapacity:_storage.count];
    for (id key in _orderedKeys) {
        if (key && _storage[key]) {
            [valuesM addObject:_storage[key]];
        }
    }
    return [valuesM copy];
}

#pragma mark - Initialization

- (instancetype)init {
    return [[WCOrderedDictionary alloc] initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _orderedKeys = [NSMutableArray arrayWithCapacity:capacity];
        _storage = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    }
    return self;
}

+ (instancetype)dictionary {
    return [[WCOrderedDictionary alloc] initWithCapacity:0];
}

+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCOrderedDictionary alloc] initWithCapacity:capacity];
}

+ (instancetype)dictionaryWithDictionary:(WCOrderedDictionary<id, id> *)otherDictionary {
    WCOrderedDictionary *dict = [[WCOrderedDictionary alloc] initWithCapacity:otherDictionary.count];
    [dict setDictionary:otherDictionary];
    return dict;
}

#pragma mark - Add

- (void)setObject:(nullable id)object forKey:(id)key {
    if (!key) {
        return;
    }
    
    if (object) {
        [_orderedKeys removeObject:key];
        [_orderedKeys addObject:key];
        [_storage setObject:object forKey:key];
    }
    else {
        [_orderedKeys removeObject:key];
        [_storage removeObjectForKey:key];
    }
}

- (void)setDictionary:(WCOrderedDictionary<id, id> *)otherDictionary {
    [_orderedKeys removeAllObjects];
    [_storage removeAllObjects];
    
    [_orderedKeys addObjectsFromArray:otherDictionary->_orderedKeys];
    [_storage addEntriesFromDictionary:otherDictionary->_storage];
}

- (void)addEntriesFromDictionary:(WCOrderedDictionary<id, id> *)otherDictionary {
    [_orderedKeys removeObjectsInArray:otherDictionary->_orderedKeys];
    [_orderedKeys addObjectsFromArray:otherDictionary->_orderedKeys];
    
    [_storage addEntriesFromDictionary:otherDictionary->_storage];
}

#pragma mark - Remove

- (void)removeAllObjects {
    [_orderedKeys removeAllObjects];
    [_storage removeAllObjects];
}

- (void)removeObjectForKey:(id)key {
    [_orderedKeys removeObject:key];
    [_storage removeObjectForKey:key];
}

- (void)removeObjectsForKeys:(NSArray<id> *)keys {
    if (![keys isKindOfClass:[NSArray class]] ||
        ([keys isKindOfClass:[NSArray class]] && keys.count == 0)) {
        return;
    }
    
    [_orderedKeys removeObjectsInArray:keys];
    [_storage removeObjectsForKeys:keys];
}

#pragma mark - Query

- (nullable id)objectForKey:(id)key {
    if (!key) {
        return nil;
    }
    
    return [_storage objectForKey:key];
}

- (NSUInteger)count {
    return [_storage count];
}

- (NSString *)description {
    NSMutableString *stringM = [NSMutableString string];
    traverse_object(stringM, self, 0, NO);
    
    return stringM;
}

- (NSString *)debugDescription {
    return [self description];
}

#pragma mark ::

// 2 spaces for indentation
#define INDENTATION @"  "

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
    else if ([object isKindOfClass:[WCOrderedDictionary class]]) {
        [stringM appendString:@"{\n"];
        
        NSArray *allKeys = [object allKeys];
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
    else {
        // call object's description method
        [stringM appendFormat:@"\"<%@: %p>\"", NSStringFromClass([object class]), object];
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

#pragma mark - Subscript (e.g. dict[@"key"])

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

#pragma mark - Index (e.g. dict[1])

__nullable WCOrderedDictionaryPair WCOrderedDictionaryPairMake(id key, id value) {
    if (key && value) {
        return [NSArray arrayWithObjects:key, value, nil];
    }
    else {
        return nil;
    }
}

- (nullable WCOrderedDictionaryPair)objectAtIndexedSubscript:(NSUInteger)index {
    if (index < _orderedKeys.count) {
        id key = _orderedKeys[index];
        id value = _storage[key];
        
        return WCOrderedDictionaryPairMake(key, value);
    }
    else {
        return nil;
    }
}

- (void)setObject:(nullable WCOrderedDictionaryPair)object atIndexedSubscript:(NSUInteger)index {
    if (index < _orderedKeys.count) {
        
        if ([object isKindOfClass:[NSArray class]] && object.count == 2) {
            id key = [object firstObject];
            id value = [object lastObject];
            
            _orderedKeys[index] = key;
            _storage[key] = value;
        }
        else if (!object) {
            id key = _orderedKeys[index];
            
            [_orderedKeys removeObjectAtIndex:index];
            [_storage removeObjectForKey:key];
        }
    }
}

#pragma mark - Convert from NSDictionary

+ (nullable WCOrderedDictionary *)orderedDictionaryFromDictionary:(NSDictionary *)dictionary {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    WCOrderedDictionary *orderedDict = [[WCOrderedDictionary alloc] initWithCapacity:dictionary.count];
    NSArray *allKeys = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull key1, id _Nonnull key2) {
        if ([key1 respondsToSelector:@selector(compare:)] && [key2 respondsToSelector:@selector(compare:)]) {
            if ([key1 compare:key2] == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            else if ([key1 compare:key2] == NSOrderedDescending) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }
        else {
            if ([[key1 description] compare:[key2 description]] == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            else if ([[key1 description] compare:[key2 description]] == NSOrderedDescending) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }
    }];
    
    for (NSString *key in allKeys) {
        [orderedDict setObject:dictionary[key] forKey:key];
    }
    
    return orderedDict;
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    // Note: use NSArray fast enumeation to implement it
    return [_orderedKeys countByEnumeratingWithState:state objects:buffer count:len];
}

@end
