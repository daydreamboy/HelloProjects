//
//  WCThreadSafeMutableArray.m
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCThreadSafeMutableArray.h"

// @see https://www.guiguan.net/ggmutabledictionary-thread-safe-nsmutabledictionary/
@implementation WCThreadSafeMutableArray {
    dispatch_queue_t isolationQueue_;
//    NSMutableDictionary *_storage;
    CFMutableArrayRef _storage;
}

#pragma mark - Public Methods

- (instancetype)init {
    self = [self initCommon];
    if (self) {
        _storage = CFArrayCreateMutable(NULL, 0, NULL);
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [self initCommon];
    if (self) {
        _storage = CFArrayCreateMutable(NULL, capacity, NULL);
    }
    return self;
}

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(isolationQueue_, ^{
        count = CFArrayGetCount(self->_storage);
    });
    return count;
}

- (void)addObject:(id)object {
    dispatch_barrier_async(isolationQueue_, ^{
        CFArrayAppendValue(self->_storage, CFBridgingRetain(object));
    });
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    dispatch_barrier_async(isolationQueue_, ^{
        CFArrayInsertValueAtIndex(self->_storage, index, CFBridgingRetain(object));
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(isolationQueue_, ^{
        CFIndex index = CFArrayGetCount(self->_storage);
        CFArrayRemoveValueAtIndex(self->_storage, index);
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async(isolationQueue_, ^{
        CFArrayRemoveValueAtIndex(self->_storage, index);
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    dispatch_barrier_async(isolationQueue_, ^{
        CFArraySetValueAtIndex(self->_storage, index, CFBridgingRetain(object));
    });
}

#pragma mark - Private Methods

- (instancetype)initCommon {
    self = [super init];
    if (self) {
        isolationQueue_ = dispatch_queue_create([@"WCThreadSafeArray Isolation Queue" UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

@end
