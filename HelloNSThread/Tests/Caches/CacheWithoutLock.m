//
//  CacheWithoutLock.m
//  Tests
//
//  Created by wesley_chen on 2019/5/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "CacheWithoutLock.h"

@interface CacheWithoutLock ()
@property (nonatomic, strong) NSMutableDictionary *cache;
@end

@implementation CacheWithoutLock

- (instancetype)init {
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)objectForKey:(NSString *)key {
    id object;
    object = _cache[key];
    
    return object;
}

- (void)setObject:(id)object forKey:(NSString *)key {
    _cache[key] = object;
}

- (void)removeObject:(id)object forKey:(NSString *)key {
    [_cache removeObjectForKey:key];
}

@end
