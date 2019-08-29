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

//- (NSString *)description {
//    
//}
//
//- (NSString *)debugDescription {
//    
//}

#pragma mark - Subscript

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    // Note: use NSArray fast enumeation to implement it
    return [_orderedKeys countByEnumeratingWithState:state objects:buffer count:len];
}

@end
