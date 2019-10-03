//
//  WCThreadTool.m
//  HelloThread
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCThreadTool.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// >= `10.0`
#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface NSObject (WCThreadTool)
- (void)WCThreadTool_callBlock;
- (void)WCThreadTool_callBlockWithObject:(id)object;
@end

@implementation NSObject (WCThreadTool)

- (void)WCThreadTool_callBlock {
    dispatch_block_t block = (id)self;
    if (block) {
        block();
    }
}

- (void)WCThreadTool_callBlockWithObject:(id)object {
    void (^block)(id) = (id)self;
    if (block) {
        block(object);
    }
}

@end

@implementation WCThreadTool

+ (void)performBlock:(dispatch_block_t)block onThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone {
    if (block && [thread isKindOfClass:[NSThread class]]) {
        dispatch_block_t blockCopy = [block copy];
        [blockCopy performSelector:@selector(WCThreadTool_callBlock) onThread:thread withObject:nil waitUntilDone:waitUntilDone];
    }
}

+ (void)performBlock:(void (^)(id))block onThread:(NSThread *)thread withObject:(id)object waitUntilDone:(BOOL)waitUntilDone {
    if (block && [thread isKindOfClass:[NSThread class]]) {
        dispatch_block_t blockCopy = [block copy];
        [blockCopy performSelector:@selector(WCThreadTool_callBlockWithObject:) onThread:thread withObject:object waitUntilDone:waitUntilDone];
    }
}

static const void *sAssociatedObjectKeyShouldStop = &sAssociatedObjectKeyShouldStop;
static const void *sAssociatedObjectKeyAddress = &sAssociatedObjectKeyAddress;

+ (NSThread *)createResidentThreadWithName:(NSString *)name startImmediately:(BOOL)startImmediately {
    
    void (^createTheadBlock)(void) = ^{
        @autoreleasepool {
            NSThread *residentThread = [NSThread currentThread];
            
            NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
            // Note: use NSRunLoopCommonModes instead of NSDefaultRunLoopMode, because
            // thread will be blocked by scrolling when use NSDefaultRunLoopMode
            [currentRunLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
            
            while (residentThread) {
                NSNumber *shouldStop = objc_getAssociatedObject(residentThread, sAssociatedObjectKeyShouldStop);
                if (shouldStop) {
                    break;
                }
                
                [currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.001]];
            }
        }
    };
    
    NSThread *thread = nil;
    if (IOS10_OR_LATER) {
        thread = [[NSThread alloc] initWithBlock:createTheadBlock];
    }
    else {
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(internal_createTheadMethod:) object:createTheadBlock];
    }
    
    NSString *address = [NSString stringWithFormat:@"%p", thread];
    objc_setAssociatedObject(thread, sAssociatedObjectKeyAddress, address, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    thread.name = name;
    if (startImmediately) {
        [thread start];
    }
    
    return thread;
}

+ (BOOL)stopResidentThread:(NSThread *)thread {
    NSString *address = [NSString stringWithFormat:@"%p", thread];
    id value = objc_getAssociatedObject(thread, sAssociatedObjectKeyAddress);
    if ([value isKindOfClass:[NSString class]] && [value isEqualToString:address]) {
        
        void (^destroyTheadBlock)(void) = ^{
            objc_setAssociatedObject(thread, sAssociatedObjectKeyShouldStop, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
            CFRunLoopStop(CFRunLoopGetCurrent());
        };
        
        [self performSelector:@selector(internal_destroyTheadMethod:) onThread:thread withObject:destroyTheadBlock waitUntilDone:NO];
        
        return YES;
    }
    
    return NO;
}

#pragma mark ::

+ (void)internal_createTheadMethod:(void (^)(void))block {
    if (block) {
        block();
    }
}

+ (void)internal_destroyTheadMethod:(void (^)(void))block {
    if (block) {
        block();
    }
}

#pragma mark ::

@end
