//
//  WCThreadSafeArray.m
//  HelloNSArray
//
//  Created by wesley_chen on 2019/8/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCThreadSafeArray.h"

@implementation WCThreadSafeArray {
@private
    dispatch_queue_t _internal_queue;
    CFMutableArrayRef _storage;
}

- (void)dealloc {
    CFRelease(self->_storage);
}

#pragma mark - Initialize

- (instancetype)init {
    return [self initWithCapacity:0];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeArray Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        _storage = CFArrayCreateMutable(kCFAllocatorDefault, (CFIndex)capacity, &kCFTypeArrayCallBacks);
    }
    return self;
}

- (instancetype)initWithPlaceholderObject:(id)object count:(NSUInteger)count {
    self = [super init];
    if (self) {
        _internal_queue = dispatch_queue_create("WCThreadSafeArray Isolation Queue", DISPATCH_QUEUE_CONCURRENT);
        _storage = CFArrayCreateMutable(kCFAllocatorDefault, (CFIndex)count, &kCFTypeArrayCallBacks);
        for (NSUInteger i = 0; i < count; i++) {
            CFArrayAppendValue(self->_storage, (__bridge const void *)(object));
        }
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
    if (!object) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (index <= count) {
            CFArraySetValueAtIndex(self->_storage, (CFIndex)index, (__bridge const void *)(object));
        }
    });
}

- (void)addObjectsFromArray:(WCThreadSafeArray<id> *)otherArray {
    if (![otherArray isKindOfClass:[WCThreadSafeArray class]]) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(otherArray->_storage);
        
        if (count > 0) {
            CFArrayAppendArray(self->_storage, otherArray->_storage, CFRangeMake(0, count));
        }
    });
}

- (void)setArray:(WCThreadSafeArray<id> *)otherArray {
    if (![otherArray isKindOfClass:[WCThreadSafeArray class]]) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(otherArray->_storage);
        
        if (count > 0) {
            CFArrayRemoveAllValues(self->_storage);
            CFArrayAppendArray(self->_storage, otherArray->_storage, CFRangeMake(0, count));
        }
    });
}

#pragma mark - Remove

- (void)removeAllObjects {
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (count) {
            CFArrayRemoveAllValues(self->_storage);
        }
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (count > 0) {
            CFArrayRemoveValueAtIndex(self->_storage, (CFIndex)(count - 1));
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (index <= count) {
            CFArrayRemoveValueAtIndex(self->_storage, (CFIndex)index);
        }
    });
}

- (void)removeObject:(id)object {
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex cfIndex = CFArrayGetFirstIndexOfValue(self->_storage, CFRangeMake(0, CFArrayGetCount(self->_storage)), (__bridge const void *)object);
        if (cfIndex != -1) {
            CFIndex count = CFArrayGetCount(self->_storage);
            if (cfIndex <= count) {
                CFArrayRemoveValueAtIndex(self->_storage, cfIndex);
            }
        }
    });
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

- (NSUInteger)indexOfObject:(id)object {
    if (!object) {
        return NSNotFound;
    }
    
    __block NSUInteger index = NSNotFound;
    dispatch_sync(_internal_queue, ^{
        // Note: search forward for the object
        CFIndex cfIndex = CFArrayGetFirstIndexOfValue(self->_storage, CFRangeMake(0, CFArrayGetCount(self->_storage)), (__bridge const void *)object);
        if (cfIndex != -1) {
            index = (NSUInteger)cfIndex;
        }
    });
    
    return index;
}

- (NSArray *)arrayRepresentation {
    __block NSArray *array;
    dispatch_sync(_internal_queue, ^{
        CFArrayRef arrayRef = CFArrayCreateCopy(kCFAllocatorDefault, self->_storage);
        // Note: https://medium.com/@hadhi631/when-to-use-bridge-bridge-transfer-cfbridgingrelease-and-bridge-retained-cfbridgingretain-4b3d2fc932df
        array = CFBridgingRelease(arrayRef);
    });
    return array;
}

#pragma mark - Sort

- (void)exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2 {
    if (index1 == index2) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        CFIndex count = CFArrayGetCount(self->_storage);
        
        if (index1 <= count && index2 <= count) {
            CFArrayExchangeValuesAtIndices(self->_storage, index1, index2);
        }
    });
}

- (void)sortUsingDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
    if (![sortDescriptors isKindOfClass:[NSArray class]] ||
        ([sortDescriptors isKindOfClass:[NSArray class]] && sortDescriptors.count == 0)) {
        return;
    }
    
    dispatch_barrier_async(_internal_queue, ^{
        NSMutableArray *arrayObject = (__bridge id)self->_storage;
        [arrayObject sortUsingDescriptors:sortDescriptors];
    });
}

#pragma mark - Subscript

- (nullable id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    [self replaceObjectAtIndex:index withObject:object];
}

@end
