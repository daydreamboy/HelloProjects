//
//  CacheWithPthread_rwlock.m
//  Tests
//
//  Created by wesley_chen on 2019/5/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithPthread_rwlock.h"
#include <pthread/pthread.h>

@interface CacheWithPthread_rwlock () {
    pthread_rwlock_t _rwlock;
}
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithPthread_rwlock

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_rwlock_init(&_rwlock, NULL);
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    pthread_rwlock_rdlock(&_rwlock);
    object = _cache[key];
    pthread_rwlock_unlock(&_rwlock);
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    pthread_rwlock_wrlock(&_rwlock);
    _cache[key] = object;
    pthread_rwlock_unlock(&_rwlock);
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    pthread_rwlock_wrlock(&_rwlock);
    [_cache removeObjectForKey:key];
    pthread_rwlock_unlock(&_rwlock);
}

@end
