//
//  WCThreadSafeDictionary.m
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCThreadSafeDictionary.h"

// @see https://www.guiguan.net/ggmutabledictionary-thread-safe-nsmutabledictionary/
@implementation WCThreadSafeDictionary {
    dispatch_queue_t isolationQueue_;
    NSMutableDictionary *_storage;
}

#pragma mark - Public Methods

- (instancetype)init {
    self = [self initCommon];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [self initCommon];
    if (self) {
        _storage = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

- (NSDictionary *)initWithContentsOfFile:(NSString *)path {
    self = [self initCommon];
    if (self) {
        _storage = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [self initCommon];
    if (self) {
        _storage = [[NSMutableDictionary alloc] initWithCoder:decoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)count {
    self = [self initCommon];
    if (self) {
        if (!objects || !keys) {
            [NSException raise:NSInvalidArgumentException format:@"objects and keys cannot be nil"];
        }
        else {
            for (NSUInteger i = 0; i < count; ++i) {
                _storage[keys[i]] = objects[i];
            }
        }
    }
    return self;
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(isolationQueue_, ^{
        count = self->_storage.count;
    });
    return count;
}

- (id)objectForKey:(id)key {
    __block id obj;
    dispatch_sync(isolationQueue_, ^{
        obj = self->_storage[key];
    });
    return obj;
}

- (NSEnumerator *)keyEnumerator {
    __block NSEnumerator *enu;
    dispatch_sync(isolationQueue_, ^{
        enu = [self->_storage keyEnumerator];
    });
    return enu;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    key = [key copyWithZone:NULL];
    dispatch_barrier_async(isolationQueue_, ^{
        self->_storage[key] = object;
    });
}

- (void)removeObjectForKey:(id)key {
    dispatch_barrier_async(isolationQueue_, ^{
        [self->_storage removeObjectForKey:key];
    });
}

#pragma mark - Private Methods

- (instancetype)initCommon {
    self = [super init];
    if (self) {
        isolationQueue_ = dispatch_queue_create([@"WCThreadSafeDictionary Isolation Queue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

@end
