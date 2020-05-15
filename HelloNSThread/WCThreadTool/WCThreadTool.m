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
#import <mach-o/dyld.h>
#import <mach-o/ldsyms.h>

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

#pragma mark - Call Stack

+ (NSString *)currentThreadCallStackString {
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSArray *callStackReturnAddresses = [NSThread callStackReturnAddresses];
    
    NSMutableString *logContent = [NSMutableString string];
    [logContent appendFormat:@"appVersion: %@\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [logContent appendFormat:@"appBuildVersion: %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    [logContent appendFormat:@"appExecutableUUID: %@\n", [self appExecutableUUID]];
    [logContent appendFormat:@"appExecutableLoadAddress: %@\n", [self appExecutableImageLoadAddress]];
    [logContent appendFormat:@"systemVersion: %@\n", [[UIDevice currentDevice] systemVersion]];
    [logContent appendFormat:@"callStackSymbols: %@\n", callStackSymbols];
    [logContent appendFormat:@"callStackReturnAddresses: %@\n", callStackReturnAddresses];
    
    return logContent;
}

#pragma mark - Utility

+ (NSString *)appExecutableImageLoadAddress {
    static NSString *sAddress;
    
    if (!sAddress) {
        const struct mach_header *executableHeader = NULL;
        for (uint32_t i = 0; i < _dyld_image_count(); i++){
            const struct mach_header *header = _dyld_get_image_header(i);
            // Note: find the image type is executable, which is the executable binary file
            if (header->filetype == MH_EXECUTE){
                executableHeader = header;
                break;
            }
        }
        sAddress = [NSString stringWithFormat:@"0x%lx", (NSInteger)executableHeader];
    }
    
    return sAddress;
}

+ (nullable NSString *)appExecutableUUID {
    static NSString *sUUID;
    static dispatch_semaphore_t sLock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sLock = dispatch_semaphore_create(1);
    });
    
    if (!sUUID) {
        dispatch_semaphore_wait(sLock, DISPATCH_TIME_FOREVER);
        
        const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
        for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
            if (((const struct load_command *)command)->cmd == LC_UUID) {
                command += sizeof(struct load_command);
                sUUID = [[NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                         command[0], command[1],
                         command[2], command[3],
                         command[4], command[5],
                         command[6], command[7],
                         command[8], command[9],
                         command[10], command[11],
                         command[12], command[13],
                         command[14], command[15]] copy];
                break;
            }
            else {
                command += ((const struct load_command *)command)->cmdsize;
            }
        }
        
        dispatch_semaphore_signal(sLock);
    }

    return sUUID;
}

@end
