//
//  CacheWithPthread_mutex.m
//  Tests
//
//  Created by wesley_chen on 2019/5/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithPthread_mutex.h"
#include <pthread/pthread.h>

@interface CacheWithPthread_mutex () {
    pthread_mutex_t _mutex;
}
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithPthread_mutex

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_mutex, NULL);
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    pthread_mutex_lock(&_mutex);
    object = _cache[key];
    pthread_mutex_unlock(&_mutex);
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    pthread_mutex_lock(&_mutex);
    _cache[key] = object;
    pthread_mutex_unlock(&_mutex);
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    pthread_mutex_lock(&_mutex);
    [_cache removeObjectForKey:key];
    pthread_mutex_unlock(&_mutex);
}

@end
