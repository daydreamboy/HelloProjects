//
//  WCThreadSafeArray.m
//  HelloNSArray
//
//  Created by wesley_chen on 2019/8/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCThreadSafeArray.h"

@implementation WCThreadSafeArray {
    dispatch_queue_t _internal_queue;
    CFMutableArrayRef _storage;
}

#pragma mark - Initialize

- (instancetype)init {
    return [[WCThreadSafeArray alloc] initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeArray Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        _storage = CFArrayCreateMutable(kCFAllocatorDefault, (CFIndex)capacity, &kCFTypeArrayCallBacks);
    }
    return self;
}

+ (instancetype)array {
    return [[WCThreadSafeArray alloc] initWithCapacity:0];
}

+ (instancetype)arrayWithCapacity:(NSUInteger)capacity {
    return [[WCThreadSafeArray alloc] initWithCapacity:capacity];
}

#pragma mark - Add

- (void)addObject:(id)object {
    if (!object) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFArrayAppendValue(self->_storage, (__bridge const void *)(object));
    });
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    if (!object) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (index <= count) {
            CFArrayInsertValueAtIndex(self->_storage, (CFIndex)index, (__bridge const void *)(object));
        }
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    
}

- (void)addObjectsFromArray:(WCThreadSafeArray<id> *)otherArray {
    
}

- (void)setArray:(WCThreadSafeArray<id> *)otherArray {
    
}

#pragma mark - Remove

- (void)removeAllObjects {
    
}

- (void)removeLastObject {
    
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    
}

- (void)removeObject:(id)object inRange:(NSRange)range {
    
}

#pragma mark - Query

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(_internal_queue, ^{
        count = (NSUInteger)(CFArrayGetCount(self->_storage));
    });
    return count;
}

- (nullable id)objectAtIndex:(NSUInteger)index {
    __block id object = nil;
    dispatch_sync(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (index < count) {
            object = CFArrayGetValueAtIndex(self->_storage, (CFIndex)index);
        }
    });
    
    return object;
}

#pragma mark - Sort

- (void)sortUsingDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
    
}

#pragma mark - Subscript

- (nullable id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    
}


@end
