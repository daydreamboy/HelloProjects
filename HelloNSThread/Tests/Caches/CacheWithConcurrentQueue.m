//
//  CacheWithConcurrentQueue.m
//  Tests
//
//  Created by wesley_chen on 2019/5/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithConcurrentQueue.h"

@interface CacheWithConcurrentQueue ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation CacheWithConcurrentQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _concurrentQueue = dispatch_queue_create("com.wc.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    __block id object;
    
    dispatch_sync(_concurrentQueue, ^{
        object = self.cache[key];
    });
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    dispatch_barrier_async(_concurrentQueue, ^{
        self.cache[key] = object;
    });
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    dispatch_barrier_async(_concurrentQueue, ^{
        [self.cache removeObjectForKey:key];
    });
}

@end
