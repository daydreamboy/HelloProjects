//
//  CacheWithNSLock.m
//  Tests
//
//  Created by wesley_chen on 2019/5/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithNSLock.h"

@interface CacheWithNSLock ()
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithNSLock

- (instancetype)init {
    self = [super init];
    if (self) {
        _lock = [[NSLock alloc] init];
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    [_lock lock];
    object = _cache[key];
    [_lock unlock];
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    [_lock lock];
    _cache[key] = object;
    [_lock unlock];
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    [_lock lock];
    [_cache removeObjectForKey:key];
    [_lock unlock];
}

@end
