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
        commonIntializer(self);
    }
    return self;
}

- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION {
    self = [super init];
    if (self) {
        commonIntializer(self);
        
        NSMutableArray *mutableProtocols = [NSMutableArray array];
        Protocol *eachInterceptedProtocol;
        va_list argumentList;
        if (firstInterceptedProtocol) {
            [mutableProtocols addObject:firstInterceptedProtocol];
            va_start(argumentList, firstInterceptedProtocol);
            while ((eachInterceptedProtocol = va_arg(argumentList, id))) {
                [mutableProtocols addObject:eachInterceptedProtocol];
            }
            va_end(argumentList);
        }
        
        _middleMan = middleMan;
        _interceptedProtocols = [mutableProtocols copy];
    }
    return self;
}

- (instancetype)initWithMiddleMan:(id)middleMan interceptedProtocolArray:(NSArray *)interceptedProtocolArray {
    self = [super init];
    if (self) {
        commonIntializer(self);
        
        _middleMan = middleMan;
        _interceptedProtocols = [interceptedProtocolArray copy];
    }
    return self;
}

- (BOOL)checkSelectorInInterceptedProtocols:(SEL)aSelector {
    __block BOOL isSelectorContainedInInterceptedProtocols = NO;
    [_interceptedProtocols enumerateObjectsUsingBlock: ^(Protocol *protocol, NSUInteger idx, BOOL *stop) {
        isSelectorContainedInInterceptedProtocols = selector_belongsToProtocol(aSelector, protocol);
        *stop = isSelectorContainedInInterceptedProtocols;
    }];
    return isSelectorContainedInInterceptedProtocols;
}

#pragma mark ::

static void commonIntializer(WCMulticastDelegate *self)
{
    self->_delegates = [NSMutableArray array];
    self->_queue = dispatch_queue_create("com.wc.WCMulticastDelegate", DISPATCH_QUEUE_SERIAL);
}

static BOOL selector_belongsToProtocol(SEL selector, Protocol *protocol) {
    // Reference: https://gist.github.com/numist/3838169
    for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
        BOOL required = optionbits & 1;
        BOOL instance = !(optionbits & (1 << 1));

        struct objc_method_description hasMethod = protocol_getMethodDescription(protocol, selector, required, instance);
        if (hasMethod.name || hasMethod.types) {
            //NSLog(@"belonged selector: %@", NSStringFromSelector(selector));
            return YES;
        }
    }

    return NO;
}

#pragma mark ::

- (void)dealloc {
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

    // if any of the delegates respond to this selector, return YES
    __block BOOL returnValue = NO;
    
    dispatch_sync(self.queue, ^{
        if ([self.middleMan respondsToSelector:selector] && [self checkSelectorInInterceptedProtocols:selector]) {
            returnValue = YES;
        }
        else {
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:selector]) {
                    returnValue = YES;
                }
            }
        }
    });
    
    return returnValue;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    __block NSMethodSignature *signature = nil;

    dispatch_sync(self.queue, ^{
        if ([self.middleMan respondsToSelector:selector] && [self checkSelectorInInterceptedProtocols:selector]) {
            signature = [self.middleMan methodSignatureForSelector:selector];
        }
        else {
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:selector]) {
                    signature = [delegate methodSignatureForSelector:selector];
                }
            }
        }
    });
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // forward the invocation to every delegate
    dispatch_sync(self.queue, ^{
        SEL selector = [invocation selector];
        if ([self.middleMan respondsToSelector:selector] && [self checkSelectorInInterceptedProtocols:selector]) {
            [invocation invokeWithTarget:self.middleMan];
        }
        else {
            for (id delegate in self.delegates) {
                if ([delegate respondsToSelector:[invocation selector]]) {
                    [invocation invokeWithTarget:delegate];
                }
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

- (BOOL)takeOverDelegateIfNeeded {
    if ([self respondsToSelector:@selector(setDelegate:)]) {
        [self performSelector:@selector(setDelegate:) withObject:self.multicastDelegate];
        return YES;
    }
    
    return NO;
}

@end
