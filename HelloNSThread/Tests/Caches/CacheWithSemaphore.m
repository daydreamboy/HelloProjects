//
//  CacheWithSemaphore.m
//  Tests
//
//  Created by wesley_chen on 2019/5/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithSemaphore.h"

@interface CacheWithSemaphore ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) dispatch_semaphore_t lock;
@end

@implementation CacheWithSemaphore

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    object = _cache[key];
    dispatch_semaphore_signal(_lock);
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    _cache[key] = object;
    dispatch_semaphore_signal(_lock);
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    [_cache removeObjectForKey:key];
    dispatch_semaphore_signal(_lock);
}

@end
