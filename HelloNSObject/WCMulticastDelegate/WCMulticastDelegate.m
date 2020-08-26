//
//  WCMulticastDelegate.m
//  HelloNSObject
//
//  Created by wesley_chen on 2020/8/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMulticastDelegate.h"
#import <objc/runtime.h>

@interface WCMulticastDelegate ()
@property (nonatomic, strong) NSMutableArray *delegates;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation WCMulticastDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [NSMutableArray array];
        _queue = dispatch_queue_create("com.wc.WCMulticastDelegate", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (BOOL)addDelegate:(id)delegate {
    if (!delegate) {
        return NO;
    }
    
    if ([self.delegates indexOfObject:delegate] != NSNotFound) {
        return NO;
    }
    
    dispatch_async(self.queue, ^{
        [self.delegates addObject:delegate];
    });
    
    return YES;
}

- (BOOL)removeDelegate:(id)delegate {
    if (!delegate) {
        return NO;
    }
    
    if ([self.delegates indexOfObject:delegate] == NSNotFound) {
        return NO;
    }
    
    dispatch_async(self.queue, ^{
        [self.delegates removeObject:delegate];
    });
    
    return YES;
}

- (BOOL)removeAllDelegate {
    dispatch_async(self.queue, ^{
        [self.delegates removeAllObjects];
    });
    
    return YES;
}

- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector])
        return YES;

    // if any of the delegates respond to this selector, return YES
    __block BOOL returnValue = NO;
    
    dispatch_sync(self.queue, ^{
        for (id delegate in self.delegates) {
            if ([delegate respondsToSelector:selector]) {
                returnValue = YES;
            }
        }
    });
    
    return returnValue;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    // can this class create the signature?
    __block NSMethodSignature *signature = [super methodSignatureForSelector:selector];

    // if not, try our delegates
    if (!signature) {
        dispatch_sync(self.queue, ^{
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:selector]) {
                    signature = [delegate methodSignatureForSelector:selector];
                }
            }
        });
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // forward the invocation to every delegate
    dispatch_sync(self.queue, ^{
        for (id delegate in self.delegates) {
            if ([delegate respondsToSelector:[invocation selector]]) {
                [invocation invokeWithTarget:delegate];
            }
        }
    });
}

@end

@implementation NSObject (WCMulticastDelegate)

static void *kAssociatedObjectKeyMulticastDelegate = &kAssociatedObjectKeyMulticastDelegate;

- (WCMulticastDelegate *)multicastDelegate {
    // do we have a WCMulticastDelegate associated with this class?
    id multicastDelegate = objc_getAssociatedObject(self, kAssociatedObjectKeyMulticastDelegate);
    if (multicastDelegate == nil) {
        // if not, create one
        multicastDelegate = [[WCMulticastDelegate alloc] init];
        objc_setAssociatedObject(self, kAssociatedObjectKeyMulticastDelegate, multicastDelegate, OBJC_ASSOCIATION_RETAIN);
    }

    return multicastDelegate;
}

@end
