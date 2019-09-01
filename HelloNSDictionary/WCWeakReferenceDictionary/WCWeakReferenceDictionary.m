//
//  WCWeakReferenceDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2019/8/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCWeakReferenceDictionary.h"

@interface WCWeakReferenceHolder : NSObject
@property (nonatomic, weak) id object;
+ (instancetype)weakReferenceHolderWithObject:(id)object;
@end
@implementation WCWeakReferenceHolder
+ (instancetype)weakReferenceHolderWithObject:(id)object {
    WCWeakReferenceHolder *holder = [WCWeakReferenceHolder new];
    holder.object = object;
    return holder;
}
@end

@interface WCWeakReferenceDictionary ()
@property (nonatomic, readwrite) WCWeakableDictionaryKeyValueMode keyValueMode;
@end

@implementation WCWeakReferenceDictionary {
    NSMutableDictionary *_storage;
}

#pragma mark - Getters

- (NSArray *)allKeys {
    return [[_storage allKeys] copy];
}

- (NSArray *)allValues {
    NSArray *values = [_storage allValues];
    NSMutableArray *valuesM = [NSMutableArray arrayWithCapacity:_storage.count];
    
    for (id object in values) {
        if ([object isKindOfClass:[WCWeakReferenceHolder class]]) {
            id realObject = [(WCWeakReferenceHolder *)object object];
            if (realObject) {
                [valuesM addObject:realObject];
            }
        }
        else {
            [valuesM addObject:object];
        }
    }
    
    return valuesM;
}

#pragma mark - Initialization

+ (WCWeakReferenceDictionary<id, id> *)strongToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToStrong capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)strongToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToWeak capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)strongToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToMixed capacity:capacity];
}

#pragma mark ::

- (instancetype)initWithKeyValuMode:(WCWeakableDictionaryKeyValueMode)keyValueMode capacity:(NSUInteger)capacity {
    if (self = [super init]) {
        _keyValueMode = keyValueMode;
        _storage = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

#pragma mark ::

#pragma mark - Add

- (void)setObject:(nullable id)object forKey:(id)key weaklyHoldInMixedMode:(BOOL)weaklyHoldInMixedMode {
    if (key) {
        if (object) {
            if (self.keyValueMode == WCWeakableDictionaryKeyValueModeStrongToWeak) {
                [_storage setObject:[WCWeakReferenceHolder weakReferenceHolderWithObject:object] forKey:key];
            }
            else if (self.keyValueMode == WCWeakableDictionaryKeyValueModeStrongToMixed) {
                if (weaklyHoldInMixedMode) {
                    [_storage setObject:[WCWeakReferenceHolder weakReferenceHolderWithObject:object] forKey:key];
                }
                else {
                    [_storage setObject:object forKey:key];
                }
            }
            else {
                [_storage setObject:object forKey:key];
            }
        }
        else {
            [_storage removeObjectForKey:key];
        }
    }
}

#pragma mark - Remove

- (void)removeAllObjects {
    [_storage removeAllObjects];
}

- (void)removeObjectForKey:(id)key {
    if (key) {
        [_storage removeObjectForKey:key];
    }
}

- (void)removeObjectsForKeys:(NSArray<id> *)keys {
    if (![keys isKindOfClass:[NSArray class]] || ([keys isKindOfClass:[NSArray class]] && keys.count == 0)) {
        return;
    }
    
    for (id key in keys) {
        [self removeObjectForKey:key];
    }
}

#pragma mark - Query

- (nullable id)objectForKey:(id)key {
    if (!key) {
        return nil;
    }
    
    id value = [_storage objectForKey:key];
    
    if (self.keyValueMode == WCWeakableDictionaryKeyValueModeStrongToWeak ||
        self.keyValueMode == WCWeakableDictionaryKeyValueModeStrongToMixed) {
        if ([value isKindOfClass:[WCWeakReferenceHolder class]]) {
            return [(WCWeakReferenceHolder *)value object];
        }
    }
    
    return value;
}

- (NSUInteger)count {
    return _storage.count;
}

- (NSDictionary<id, id> *)dictionaryRepresentation {
    return [_storage copy];
}

- (NSString *)description {
    NSMutableString *stringM = [NSMutableString string];
    traverse_object(stringM, self, 0, NO);
    
    return stringM;
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
    else if ([object isKindOfClass:[WCWeakReferenceDictionary class]]) {
        [stringM appendString:@"{\n"];
        
        NSArray *allKeys = [object allKeys];
        NSUInteger numberOfAllKeys = [allKeys count];
        for (NSUInteger i = 0; i < numberOfAllKeys; i++) {
            id key = allKeys[i];
            traverse_object(stringM, key, depth + 1, NO);
            
            id value = [object objectForKey:key];
            if ([value isKindOfClass:[WCWeakReferenceHolder class]]) {
                value = [(WCWeakReferenceHolder *)object object];
            }
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
    else if ([object isKindOfClass:[NSNull class]]) {
        [stringM appendString:@"null"];
    }
    else if (object == nil) {
        [stringM appendString:@"\"<nil>\""];
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

#pragma mark - Subscript

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key weaklyHoldInMixedMode:NO];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_storage countByEnumeratingWithState:state objects:buffer count:len];
}

@end
