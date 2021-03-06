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
#import "WCMachOTool.h"

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

+ (BOOL)performBlockOnMainThread:(void (^)(void))block {
    if (!block) {
        return NO;
    }
    
    if ([NSThread isMainThread]) {
        !block ?: block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            !block ?: block();
        });
    }
    
    return YES;
}

#pragma mark -

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

#pragma mark - Call Stack

+ (NSString *)currentThreadCallStackString {
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSArray *callStackReturnAddresses = [NSThread callStackReturnAddresses];
    
    NSMutableString *logContent = [NSMutableString string];
    [logContent appendFormat:@"appVersion: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [logContent appendFormat:@"appBuildVersion: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [logContent appendFormat:@"appExecutableUUID: %@\n", [WCMachOTool appExecutableUUID]];
    [logContent appendFormat:@"appExecutableLoadAddress: %@\n", [WCMachOTool appExecutableImageLoadAddress]];
    [logContent appendFormat:@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]];
    [logContent appendFormat:@"callStackSymbols: %@\n", callStackSymbols];
    [logContent appendFormat:@"callStackReturnAddresses: %@\n", callStackReturnAddresses];
    
    return logContent;
}

#pragma mark - Task Schedule

+ (BOOL)recursiveCallWithIterateBlock:(WCThreadTool_iterateBlockType)iterateBlock transmitData:(id _Nullable)transmitData completionBlock:(WCThreadTool_completionBlockType)completionBlock {
    if (!iterateBlock || !completionBlock) {
        return NO;
    }
    
    NSMutableArray *containerM = [NSMutableArray array];
    NSUInteger i = 1;
    
    [self recursive_recursiveCallWithContainer:containerM count:i transmitData:transmitData iterateBlock:(WCThreadTool_iterateBlockType)iterateBlock completionBlock:completionBlock];
    
    return YES;
}

#pragma mark ::

+ (void)recursive_recursiveCallWithContainer:(NSMutableArray *)container count:(NSUInteger)count transmitData:(id _Nullable)transmitData iterateBlock:(WCThreadTool_iterateBlockType)iterateBlock completionBlock:(WCThreadTool_completionBlockType)completionBlock {
    
    WCThreadTool_shouldContinueBlockType checkShouldContinueBlock = ^(NSMutableArray *container, NSError *error, BOOL shouldContinue, id _Nullable transmitData) {
        if (shouldContinue) {
            [self recursive_recursiveCallWithContainer:container count:count + 1 transmitData:transmitData iterateBlock:iterateBlock completionBlock:completionBlock];
        }
        else {
            completionBlock(container, error, count, transmitData);
        }
    };
    
    iterateBlock(container, count, transmitData, checkShouldContinueBlock);
}

#pragma mark ::

@end
