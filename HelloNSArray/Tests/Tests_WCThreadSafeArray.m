//
//  Tests_WCThreadSafeArray.m
//  Tests
//
//  Created by wesley_chen on 2019/8/30.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCThreadSafeArray.h"

#define ITERATIONS 10000

@interface Tests_WCThreadSafeArray : XCTestCase

@end

@implementation Tests_WCThreadSafeArray

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)benchmarkWithCache:(WCThreadSafeArray<NSString *> *)cache {
    NSMutableArray *values = [NSMutableArray array];
    
    for (long i = 0; i < ITERATIONS; i++) {
        [values addObject:[NSString stringWithFormat:@"value%ld", i]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    CFTimeInterval startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            [cache addObject:values[i]];
        });
    }
    
    for (int i = 0; i < ITERATIONS; i++) {
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            NSInteger min = 0;
            NSInteger max = cache.count;
            NSInteger randomIndex = min + arc4random() % (max-min);
            
            object = cache[randomIndex];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ns", @(ITERATIONS), ((endTime - startTime) * 1000000));
    
    XCTAssertTrue(cache.count == ITERATIONS);
    
    // Make sure the values were added correctly
    for (NSInteger i = 0; i < cache.count; i++) {
        NSString *expected = [NSString stringWithFormat:@"value%ld", (long)i];
        NSUInteger index = [cache indexOfObject:expected];
        XCTAssertTrue(index != NSNotFound);
    }
}

#pragma mark - Test Methods

- (void)test_thread_safe {
    WCThreadSafeArray<NSString *> *cache = [WCThreadSafeArray array];
    [self benchmarkWithCache:cache];
}

@end
