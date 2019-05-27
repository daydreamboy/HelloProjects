//
//  Tests_issues.m
//  Tests
//
//  Created by wesley_chen on 2019/5/24.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "CacheWithConcurrentQueue.h"

#define ITERATIONS 10000

@interface Tests_issues : XCTestCase

@end

@implementation Tests_issues

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)benchmarkWithCache:(id<Cache>)cache {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    
    for (int i = 0; i < ITERATIONS; i++) {
        [keys addObject:[NSString stringWithFormat:@"key%d", i]];
        [values addObject:[NSString stringWithFormat:@"value%d", i]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    CFTimeInterval startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            [cache setObject:values[i] forKey:keys[i]];
        });
        
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            object = [cache objectForKey:keys[i]];
        });

    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ns", @(ITERATIONS), ((endTime - startTime) * 1000000));
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        NSInteger index = [keys indexOfObject:key];
        XCTAssert([values[index] isEqualToString:[cache objectForKey:key]]);
    }
}

#pragma mark - Test Methods

- (void)test_CacheWithConcurrentQueue {
    CacheWithConcurrentQueue *cache = [CacheWithConcurrentQueue new];
    [self benchmarkWithCache:cache];
}

@end
