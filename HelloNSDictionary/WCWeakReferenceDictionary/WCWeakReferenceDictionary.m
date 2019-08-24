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
    NSMapTable *_storage;
}

#pragma mark - Getters

- (NSArray *)allKeys {
    NSMutableArray *keysM = [NSMutableArray arrayWithCapacity:_storage.count];
    
    NSEnumerator *enumerator = [_storage keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        [keysM addObject:key];
    }
    
    return [keysM copy];
}

- (NSArray *)allValues {
    NSMutableArray *valuesM = [NSMutableArray arrayWithCapacity:_storage.count];
    
    NSEnumerator *enumerator = [_storage objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
        if ([value isKindOfClass:[WCWeakReferenceHolder class]]) {
            id object = ((WCWeakReferenceHolder *)value).object;
            if (object) {
                [valuesM addObject:object];
            }
        }
        else {
            [valuesM addObject:value];
        }
    }
    
    return [valuesM copy];
}

#pragma mark - Initialization

+ (WCWeakReferenceDictionary<id, id> *)strongToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToStrong capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)strongToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToWeak capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)weakToStrongObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeWeakToStrong capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)weakToWeakObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeWeakToWeak capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)strongToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToStrong capacity:capacity];
}

+ (WCWeakReferenceDictionary<id, id> *)weakToMixedObjectsDictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCWeakReferenceDictionary alloc] initWithKeyValuMode:WCWeakableDictionaryKeyValueModeStrongToStrong capacity:capacity];
}

#pragma mark ::

- (instancetype)initWithKeyValuMode:(WCWeakableDictionaryKeyValueMode)keyValueMode capacity:(NSUInteger)capacity {
    if (self = [super init]) {
        NSPointerFunctionsOptions keyOptions;
        NSPointerFunctionsOptions valueOptions;

        switch (keyValueMode) {
            case WCWeakableDictionaryKeyValueModeStrongToWeak:
            default: {
                keyOptions = NSPointerFunctionsStrongMemory;
                valueOptions = NSPointerFunctionsWeakMemory;
                break;
            }
            case WCWeakableDictionaryKeyValueModeStrongToStrong: {
                keyOptions = NSPointerFunctionsStrongMemory;
                valueOptions = NSPointerFunctionsStrongMemory;
                break;
            }
            case WCWeakableDictionaryKeyValueModeWeakToStrong: {
                keyOptions = NSPointerFunctionsWeakMemory;
                valueOptions = NSPointerFunctionsStrongMemory;
                break;
            }
            case WCWeakableDictionaryKeyValueModeWeakToWeak: {
                keyOptions = NSPointerFunctionsWeakMemory;
                valueOptions = NSPointerFunctionsWeakMemory;
                break;
            }
            case WCWeakableDictionaryKeyValueModeStrongToMixed: {
                keyOptions = NSPointerFunctionsStrongMemory;
                valueOptions = NSPointerFunctionsStrongMemory;
                break;
            }
            case WCWeakableDictionaryKeyValueModeWeakToMixed: {
                keyOptions = NSPointerFunctionsStrongMemory;
                valueOptions = NSPointerFunctionsStrongMemory;
                break;
            }
        }
        
        _storage = [[NSMapTable alloc] initWithKeyOptions:keyOptions valueOptions:valueOptions capacity:capacity];
    }
    return self;
}

#pragma mark ::

#pragma mark - Add

- (void)setObject:(nullable id)object forKey:(id)key {
    if (key) {
        if (object) {
            [_storage setObject:object forKey:key];
        }
        else {
            [_storage removeObjectForKey:key];
        }
    }
}

- (void)setWeakReferenceObject:(nullable id)object forKey:(id)key {
    if (key) {
        if (object) {
            if (self.keyValueMode == WCWeakableDictionaryKeyValueModeStrongToMixed ||
                self.keyValueMode == WCWeakableDictionaryKeyValueModeWeakToMixed) {
                [_storage setObject:[WCWeakReferenceHolder weakReferenceHolderWithObject:object] forKey:key];
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

- (void)addEntriesFromDictionary:(WCWeakReferenceDictionary<id, id> *)otherDictionary {
    if (![otherDictionary isKindOfClass:[WCWeakReferenceDictionary class]] ||
        ([otherDictionary isKindOfClass:[WCWeakReferenceDictionary class]] && otherDictionary.count == 0)) {
        return;
    }
    
    NSArray *keys = [otherDictionary allKeys];
    for (NSInteger i = 0; i < keys.count; i++) {
        id key = keys[i];
        id value = otherDictionary[key];
        [self setObject:value forKey:key];
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
    
    return [_storage objectForKey:key];
}

- (NSUInteger)count {
    return _storage.count;
}

- (NSDictionary<id, id> *)dictionaryRepresentation {
    return [_storage dictionaryRepresentation];
}

#pragma mark - Subscript

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    NSUInteger count = 0;
    
    unsigned long countOfItemsAlreadyEnumerated = state->state;
    
    if (countOfItemsAlreadyEnumerated == 0) {
        state->mutationsPtr = &state->extra[0];
    }
    
    if (countOfItemsAlreadyEnumerated < _storage.count) {
        __unsafe_unretained NSArray *keys = [self allKeys];
        state->itemsPtr = &keys;
        
        count = _storage.count;
        
        countOfItemsAlreadyEnumerated = _storage.count;
    }
    
    state->state = countOfItemsAlreadyEnumerated;
    
    return count;
}

@end
