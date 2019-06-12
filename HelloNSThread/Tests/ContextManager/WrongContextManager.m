//
//  WrongContextManager.m
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WrongContextManager.h"

#define OpaqueSharedContextClass WrongOpaqueSharedContext

@interface OpaqueSharedContextClass : NSObject <MPMSharedContext>
@property (nonatomic, copy) NSString *name;
@end

@implementation OpaqueSharedContextClass
// Note: not implements MPMSharedContext
@end

@implementation WrongContextManager {
    NSMutableDictionary *_storage;
    dispatch_queue_t _internal_queue;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static WrongContextManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WrongContextManager alloc] init];
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
    dispatch_sync(_internal_queue, ^{ // ERROR: dispatch_sync used here is not thread safe
        context = self->_storage[key];
        if (!context) {
            context = [OpaqueSharedContextClass new];
            self->_storage[key] = context;
        }
    });
    
    return context;
}

@end
