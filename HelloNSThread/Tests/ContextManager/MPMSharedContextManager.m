//
//  MPMSharedContextManager.m
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MPMSharedContextManager.h"

#define OpaqueSharedContextClass    MPMOpaqueSharedContext
#define OpaqueContextItemClass      MPMOpaqueContextItem

@interface OpaqueContextItemClass : NSObject <MPMContextItem>
@end

@implementation OpaqueContextItemClass

@synthesize timestamp = _timestamp;
@synthesize object = _object;

+ (instancetype)itemWithObject:(id)object {
    OpaqueContextItemClass *instance = [[OpaqueContextItemClass alloc] init];
    instance->_object = object;
    instance->_timestamp = [[NSDate date] timeIntervalSince1970];
    return instance;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ts: %f, %@", _timestamp, _object];
}

@end

@interface OpaqueSharedContextClass : NSObject <MPMSharedContext>
@property (nonatomic, copy) NSString *name;
@end

@implementation OpaqueSharedContextClass {
    NSMutableDictionary *_map;
    NSMutableArray *_list;
    dispatch_queue_t _map_queue;
    dispatch_queue_t _list_queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _map_queue = dispatch_queue_create("MPMOpaqueSharedContext.map.queue", DISPATCH_QUEUE_CONCURRENT);
        _list_queue = dispatch_queue_create("MPMOpaqueSharedContext.list.queue", DISPATCH_QUEUE_CONCURRENT);
        _map = [NSMutableDictionary dictionaryWithCapacity:50];
        _list = [NSMutableArray arrayWithCapacity:50];
    }
    return self;
}

#pragma mark - List Semantic

- (void)appendItemWithObject:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_barrier_async(_list_queue, ^{
        [self->_list addObject:[OpaqueContextItemClass itemWithObject:object]];
    });
}

- (nullable id<MPMContextItem>)itemAtIndex:(NSUInteger)index {
    __block id<MPMContextItem> item;
    dispatch_sync(_list_queue, ^{
        if (index < [self->_list count]) {
            item = self->_list[index];
        }
    });
    
    return item;
}

- (NSArray<id<MPMContextItem>> *)allItems {
    __block NSArray *list;
    
    dispatch_sync(_list_queue, ^{
        list = [self->_list copy];
    });
    
    return list;
}

#pragma mark - Map Semantic

- (void)setItemWithObject:(id)object forKey:(NSString *)key {
    if (!object || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    dispatch_barrier_async(_map_queue, ^{
        self->_map[key] = [OpaqueContextItemClass itemWithObject:object];
    });
}

- (nullable id<MPMContextItem>)itemForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    __block id<MPMContextItem> item;
    dispatch_sync(_map_queue, ^{
        item = self->_map[key];
    });
    
    return item;
}

@end

@implementation MPMSharedContextManager {
    NSMutableDictionary *_storage;
    dispatch_queue_t _internal_queue;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MPMSharedContextManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[MPMSharedContextManager alloc] init];
    });
    
    return sInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
        _internal_queue = dispatch_queue_create("MPMContextManager.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (nullable id<MPMSharedContext>)objectForKeyedSubscript:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    __block id<MPMSharedContext> context;
    dispatch_barrier_sync(_internal_queue, ^{
        context = self->_storage[key];
        if (!context) {
            context = [OpaqueSharedContextClass new];
            self->_storage[key] = context;
        }
    });
    
    return context;
}

@end
