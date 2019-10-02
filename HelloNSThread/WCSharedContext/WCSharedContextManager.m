//
//  WCSharedContextManager.m
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCSharedContextManager.h"

#define OpaqueSharedContextClass    WCOpaqueSharedContext
#define OpaqueContextItemClass      WCOpaqueContextItem

#pragma mark -

@interface OpaqueContextItemClass : NSObject <WCContextItem, NSCopying>
@end

@implementation OpaqueContextItemClass

@synthesize timestamp = _timestamp;
@synthesize object = _object;

+ (instancetype)itemWithObject:(id<WCContextItemObjectT>)object {
    OpaqueContextItemClass *instance = [[OpaqueContextItemClass alloc] init];
    instance->_object = object;
    instance->_timestamp = [[NSDate date] timeIntervalSince1970];
    return instance;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ts: %f, %@", _timestamp, _object];
}

- (id)copyWithZone:(NSZone *)zone {
    OpaqueContextItemClass *copiedObject = [[OpaqueContextItemClass alloc] init];
    if ([self.object respondsToSelector:@selector(copyWithZone:)]) {
        copiedObject->_object = [self.object copyWithZone:zone];
    }
    
    copiedObject->_timestamp = self.timestamp;
    return copiedObject;
}

@end

#pragma mark -

@interface OpaqueSharedContextClass : NSObject <WCSharedContext>
@property (nonatomic, copy) NSString *name;
@end

@implementation OpaqueSharedContextClass {
    NSMutableDictionary *_map;
    NSMutableArray *_list;
    NSMutableDictionary<NSString *, NSMutableArray *> *_map_nesting_list;
    dispatch_queue_t _map_queue;
    dispatch_queue_t _list_queue;
    dispatch_queue_t _map_nesting_list_queue;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _map_queue = dispatch_queue_create("MPMOpaqueSharedContext.map.queue", DISPATCH_QUEUE_CONCURRENT);
        _list_queue = dispatch_queue_create("MPMOpaqueSharedContext.list.queue", DISPATCH_QUEUE_CONCURRENT);
        _map_nesting_list_queue = dispatch_queue_create("MPMOpaqueSharedContext.map_nesting_list.queue", DISPATCH_QUEUE_CONCURRENT);
        _map = [NSMutableDictionary dictionaryWithCapacity:50];
        _list = [NSMutableArray arrayWithCapacity:50];
        _map_nesting_list = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    return self;
}

#pragma mark - List Semantic

- (void)appendItemWithObject:(id<WCContextItemObjectT>)object {
    if (!object) {
        return;
    }
    
    dispatch_barrier_async(_list_queue, ^{
        [self->_list addObject:[OpaqueContextItemClass itemWithObject:object]];
    });
}

- (nullable id<WCContextItem>)itemAtIndex:(NSUInteger)index {
    __block id<WCContextItem> item;
    dispatch_sync(_list_queue, ^{
        if (index < [self->_list count]) {
            item = [self->_list[index] copy];
        }
    });
    
    return item;
}

- (NSArray<id<WCContextItem>> *)allItems {
    __block NSArray *list;
    
    dispatch_sync(_list_queue, ^{
        list = [self->_list copy];
    });
    
    return list;
}

- (void)cleanupForList {
    dispatch_barrier_async(_list_queue, ^{
        [self->_list removeAllObjects];
    });
}

#pragma mark - Map Semantic

- (void)setItemWithObject:(id<WCContextItemObjectT>)object forKey:(NSString *)key {
    if (!object || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    dispatch_barrier_async(_map_queue, ^{
        self->_map[key] = [OpaqueContextItemClass itemWithObject:object];
    });
}

- (nullable id<WCContextItem>)itemForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    __block id<WCContextItem> item;
    dispatch_sync(_map_queue, ^{
        item = [self->_map[key] copy];
    });
    
    return item;
}

- (void)cleanupForMap {
    dispatch_barrier_async(_map_queue, ^{
        [self->_map removeAllObjects];
    });
}

#pragma mark - Map Nesting List Semantic

- (void)appendItemWithObject:(id<WCContextItemObjectT>)object forKey:(NSString *)key {
    if (!object || ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    dispatch_barrier_async(_map_nesting_list_queue, ^{
        if (!self->_map_nesting_list[key]) {
            self->_map_nesting_list[key] = [NSMutableArray arrayWithCapacity:50];
        }
        
        [self->_map_nesting_list[key] addObject:[OpaqueContextItemClass itemWithObject:object]];
    });
}

- (nullable NSArray<id<WCContextItem>> *)itemListForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    __block id<WCContextItem> item;
    dispatch_sync(_map_queue, ^{
        item = [self->_map[key] copy];
    });
    
    return item;
}

- (void)cleanupForMapNestingList {
    
}

@end

#pragma mark -

@implementation WCSharedContextManager {
    NSMutableDictionary *_storage;
    dispatch_queue_t _internal_queue;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WCSharedContextManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCSharedContextManager alloc] initInternally];
    });
    
    return sInstance;
}

- (instancetype)initInternally {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
        _internal_queue = dispatch_queue_create("MPMContextManager.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (nullable id<WCSharedContext>)objectForKeyedSubscript:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    __block id<WCSharedContext> context;
    dispatch_barrier_sync(_internal_queue, ^{
        context = self->_storage[key];
        if (!context) {
            context = [OpaqueSharedContextClass new];
            self->_storage[key] = context;
        }
    });
    
    return context;
}

- (BOOL)removeSharedContextForKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        [self->_storage removeObjectForKey:key];
    });
    
    return YES;
}

@end
