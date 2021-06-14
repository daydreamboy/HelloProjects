//
//  WCXCTestCaseTool.m
//  HelloXCTestCase
//
//  Created by wesley_chen on 2019/9/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCXCTestCaseTool.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation WCXCTestCaseTool

static const char * const SemaphoreObjectTagKey = "SemaphoreObjectTagKey";

+ (BOOL)runAsyncTaskWithXCTestCase:(XCTestCase *)testCase asyncTaskBlock:(void (^)(void))asyncTaskBlock {
    if (![testCase isKindOfClass:[XCTestCase class]] || asyncTaskBlock == nil) {
        return NO;
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    objc_setAssociatedObject(testCase, SemaphoreObjectTagKey, semaphore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    asyncTaskBlock();
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        //NSLog(@"[Debug]: %@", [NSDate date]);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
    }
    
    return YES;
}

+ (BOOL)signalAsyncBlockCompletedXCTestCase:(XCTestCase *)testCase completionBlock:(void (^)(void))completionBlock {
    if (![testCase isKindOfClass:[XCTestCase class]] || completionBlock == nil) {
        return NO;
    }
    
    dispatch_semaphore_t semaphore = objc_getAssociatedObject(testCase, SemaphoreObjectTagKey);
    if (semaphore) {
        completionBlock();
        dispatch_semaphore_signal(semaphore);
    }
    
    return YES;
}

#pragma mark - Timing Measure

+ (BOOL)timingMesaureAverageWithCount:(NSUInteger)count block:(void (^)(void))block {
    if (count == 0 || !block) {
        return NO;
    }
    
    NSTimeInterval startTime;
    NSTimeInterval endTime;
    
    startTime = CACurrentMediaTime();
    for (NSUInteger i = 0; i < count; ++i) {
        block();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"average: %f s, count: %ld", (endTime - startTime) / count, (long)count);
    
    return YES;
}

@end
