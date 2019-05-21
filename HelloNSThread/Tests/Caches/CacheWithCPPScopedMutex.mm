//
//  CacheWithCPPScopedMutex.m
//  Tests
//
//  Created by wesley_chen on 2019/5/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithCPPScopedMutex.h"
#import "ScopedMutex.h"

@interface CacheWithCPPScopedMutex () {
    PERF::Mutex _mutex;
}
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithCPPScopedMutex

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    PERF::MutexLocker l(_mutex);
    return _cache[key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    PERF::MutexLocker l(_mutex);
    self.cache[key] = object;
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    PERF::MutexLocker l(_mutex);
    [self.cache removeObjectForKey:key];
}

@end
