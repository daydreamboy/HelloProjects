//
//  CacheWithKeywordSynchronized.m
//  Tests
//
//  Created by wesley_chen on 2019/5/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithKeywordSynchronized.h"

@interface CacheWithKeywordSynchronized ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithKeywordSynchronized

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    
    @synchronized (_cache) {
        object = _cache[key];
    }
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    @synchronized (_cache) {
        _cache[key] = object;
    }
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    @synchronized (_cache) {
        [_cache removeObjectForKey:key];
    }
}

@end
