//
//  CacheWithSerialQueue.m
//  Tests
//
//  Created by wesley_chen on 2019/5/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithSerialQueue.h"

@interface CacheWithSerialQueue ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation CacheWithSerialQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("com.wc.serialQueue", DISPATCH_QUEUE_SERIAL);
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    __block id object;
    
    dispatch_sync(_serialQueue, ^{
        object = self.cache[key];
    });
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    dispatch_sync(_serialQueue, ^{
        self.cache[key] = object;
    });
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    dispatch_sync(_serialQueue, ^{
        [self.cache removeObjectForKey:key];
    });
}

@end
