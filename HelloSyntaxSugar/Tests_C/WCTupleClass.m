//
//  WCTupleClass.m
//  Tests_C
//
//  Created by wesley_chen on 2019/6/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCTupleClass.h"

@interface WCTupleClass () {
    NSPointerArray *_internal_storage;
}

@end

@implementation WCTupleClass

+ (id)sentinel {
    static dispatch_once_t onceToken;
    static id sSentinel = nil;
    dispatch_once(&onceToken, ^{
        sSentinel = [[NSObject alloc] init];
    });
    
    return sSentinel;
}

- (instancetype)initWithObjects:(void *)objects, ... {
    self = [self init];
    if (self) {
        va_list args;
        va_start(args, objects);
        void *object = objects;
        id sentinel = [WCTupleClass sentinel];
        
        while (object != (__bridge void *)sentinel) {
            [_internal_storage addPointer:object];
            object = va_arg(args, void *);
        }
        
        va_end(args);
    }

    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _internal_storage = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality];
    }
    return self;
}

@end
