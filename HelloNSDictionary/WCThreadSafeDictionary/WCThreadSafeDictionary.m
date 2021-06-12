//
//  WCThreadSafeDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCThreadSafeDictionary.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation WCThreadSafeDictionary {
    dispatch_queue_t _internal_queue;
    CFMutableDictionaryRef _storage;
}

- (void)dealloc {
    CFRelease(self->_storage);
}

#pragma mark - Initialize

- (instancetype)init {
    self = [self initWithCapacity:0];
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeDictionary Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, (CFIndex)capacity, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

+ (instancetype)dictionary {
    return [[WCThreadSafeDictionary alloc] init];
}

+ (instancetype)dictionaryWithCapacity:(NSUInteger)capacity {
    return [[WCThreadSafeDictionary alloc] initWithCapacity:capacity];
}

#pragma mark - Property

- (NSArray *)allKeys {
    NSMutableArray *keysM = [NSMutableArray array];
    dispatch_sync(_internal_queue, ^{
        // @see https://stackoverflow.com/a/2283573
        CFIndex size = CFDictionaryGetCount(self->_storage);
        CFTypeRef *keysTypeRef = (CFTypeRef *)malloc(size * sizeof(CFTypeRef));
        CFDictionaryGetKeysAndValues(self->_storage, (const void **)keysTypeRef, NULL);
        const void **keys = (const void **)keysTypeRef;
        
        for (NSInteger i = 0; i < size; ++i) {
            [keysM addObject:(__bridge id)keys[i]];
        }
        free(keysTypeRef);
    });
    
    return [keysM copy];
}

- (NSArray *)allValues {
    NSMutableArray *valuesM = [NSMutableArray array];
    dispatch_sync(_internal_queue, ^{
        CFIndex size = CFDictionaryGetCount(self->_storage);
        CFTypeRef *valuesTypeRef = (CFTypeRef *)malloc(size * sizeof(CFTypeRef));
        CFDictionaryGetKeysAndValues(self->_storage, NULL, (const void **)valuesTypeRef);
        const void **values = (const void **)valuesTypeRef;
        
        for (NSInteger i = 0; i < size; ++i) {
            [valuesM addObject:(__bridge id)values[i]];
        }
        free(valuesTypeRef);
    });
    
    return [valuesM copy];
}

#pragma mark - Access

- (nullable id)objectForKey:(id)key {
    if (key == nil) {
        return nil;
    }
    
    __block id value;
    dispatch_sync(_internal_queue, ^{
        value = CFDictionaryGetValue(self->_storage, (__bridge const void *)(key));
    });
    return value;
}

- (void)setObject:(nullable id)object forKey:(id)key {
    dispatch_barrier_async(_internal_queue, ^{
        if (object) {
            CFDictionarySetValue(self->_storage, (__bridge const void *)(key), (__bridge const void *)(object));
        }
        else {
            CFDictionaryRemoveValue(self->_storage, (__bridge const void *)(key));
        }
    });
}

- (void)removeAllObjects {
    dispatch_barrier_async(_internal_queue, ^{
        CFDictionaryRemoveAllValues(self->_storage);
    });
}

- (void)removeObjectForKey:(id)key {
    if (key) {
        [self setObject:nil forKey:key];
    }
}

- (void)removeObjectsForKeys:(NSArray *)keys {
    if (![keys isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (keys.count == 0) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            CFDictionaryRemoveValue(self->_storage, (__bridge const void *)(key));
        }];
    });
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_internal_queue, ^{
        count = (NSUInteger)(CFDictionaryGetCount(self->_storage));
    });
    return count;
}

#pragma mark - Subscript

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

#pragma mark - Fast enumeration (NSFastEnumeration)

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id  _Nullable __unsafe_unretained [])buffer count:(NSUInteger)len {
    __block NSUInteger count = 0;
    
    dispatch_sync(_internal_queue, ^{
        NSDictionary *dict = (__bridge NSDictionary *)(_storage);
        count = [dict countByEnumeratingWithState:state objects:buffer count:len];
        /*
        unsigned long countOfItemsAlreadyEnumerated = state->state;
        
        if (countOfItemsAlreadyEnumerated == 0) {
            state->mutationsPtr = &state->extra[0];
        }
        
        long size = CFDictionaryGetCount(self->_storage);
        
        if (countOfItemsAlreadyEnumerated < size) {
            CFTypeRef *keysTypeRef = (CFTypeRef *)malloc( size * sizeof(CFTypeRef) );
            CFDictionaryGetKeysAndValues(self->_storage, (const void **)keysTypeRef, NULL);
            const void **keys = (const void **)keysTypeRef;
            
            state->itemsPtr = (void *)keysTypeRef;
            
            // We must return how many items are in state->itemsPtr.
            // We are returning all of our items at once so set count equal to the size of _list.
            count = size;
            countOfItemsAlreadyEnumerated = size;
        }
        else {
            // We've already provided all our items.  Signal that we are finished by returning 0.
            count = 0;
        }
        
        // Update state->state with the new value of countOfItemsAlreadyEnumerated so that it is
        // preserved for the next invocation.
        state->state = countOfItemsAlreadyEnumerated;
         */
    });

    return count;
}

@end
