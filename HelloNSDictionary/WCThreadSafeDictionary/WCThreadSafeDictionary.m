//
//  WCThreadSafeDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCThreadSafeDictionary.h"
#import <CoreFoundation/CoreFoundation.h>

// @see https://www.guiguan.net/ggmutabledictionary-thread-safe-nsmutabledictionary/
@implementation WCThreadSafeDictionary {
    dispatch_queue_t _internal_queue;
    CFMutableDictionaryRef _storage;
}

#pragma mark - Public Methods

- (instancetype)initWithKeyValueMode:(WCThreadSafeDictionaryKeyValueMode)mode {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeDictionary Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        
        switch (mode) {
            case WCThreadSafeDictionaryKeyValueModePrimitiveToObject: {
                _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
                break;
            }
            case WCThreadSafeDictionaryKeyValueModePrimitiveToPrimitive: {
                _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);
                break;
            }
            case WCThreadSafeDictionaryKeyValueModeObjectToPrimitive: {
                _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, NULL);
                break;
            }
            case WCThreadSafeDictionaryKeyValueModeObjectToObject:
            default: {
                _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
                break;
            }
        }
    }
    return self;
}

+ (instancetype)dictionary {
    return [[WCThreadSafeDictionary alloc] initWithKeyValueMode:WCThreadSafeDictionaryKeyValueModeObjectToObject];
}

- (nullable const void *)objectForKey:(const void *)key {
    if (key == nil) {
        return nil;
    }
    
    __block const void *value;
    dispatch_sync(_internal_queue, ^{
        value = CFDictionaryGetValue(self->_storage, key);
    });
    return value;
}

- (void)setObject:(nullable const void *)object forKey:(const void *)key {
    dispatch_barrier_async(_internal_queue, ^{
        if (object) {
            CFDictionarySetValue(self->_storage, key, object);
        }
        else {
            CFDictionaryRemoveValue(self->_storage, key);
        }
    });
}

- (void)removeAllObjects {
    dispatch_barrier_async(_internal_queue, ^{
        CFDictionaryRemoveAllValues(self->_storage);
    });
}

- (void)removeObjectForKey:(const void *)key {
    if (key) {
        [self setObject:nil forKey:key];
    }
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_internal_queue, ^{
        count = (NSUInteger)(CFDictionaryGetCount(self->_storage));
    });
    return count;
}

#pragma mark - Subscripting

- (nullable const void *)objectForKeyedSubscript:(const void *)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable const void *)object forKeyedSubscript:(const void *)key {
    [self setObject:object forKey:key];
}

@end
