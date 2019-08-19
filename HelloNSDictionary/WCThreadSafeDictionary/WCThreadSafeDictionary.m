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

- (instancetype)init {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeDictionary Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        _storage = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

+ (instancetype)dictionary {
    return [[WCThreadSafeDictionary alloc] init];
}

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

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_internal_queue, ^{
        count = (NSUInteger)(CFDictionaryGetCount(self->_storage));
    });
    return count;
}

#pragma mark - Subscripting

- (nullable id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(nullable id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

@end
