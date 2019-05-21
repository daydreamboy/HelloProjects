//
//  Tests_synchronize_concurrent_reads_single_write.m
//  Tests
//
//  Created by wesley_chen on 2019/5/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CacheWithNSLock.h"
#import "CacheWithNSRecursiveLock.h"
#import "CacheWithKeywordSynchronized.h"
#import "CacheWithSerialQueue.h"
#import "CacheWithConcurrentQueue.h"
#import "CacheWithCPPScopedMutex.h"
#import "CacheWithoutLock.h"
#import "CacheWithPthread_rwlock.h"

#import <dispatch/dispatch.h>

#define ITERATIONS 10000

@interface Tests_synchronize_concurrent_reads_single_write : XCTestCase

@end

@implementation Tests_synchronize_concurrent_reads_single_write

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
    }
    
    for (int i = 0; i < ITERATIONS; i++) {
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            object = [cache objectForKey:keys[i]];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for inserting %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        NSInteger index = [keys indexOfObject:key];
        XCTAssert([values[index] isEqualToString:[cache objectForKey:key]]);
    }
}

#pragma mark - Test Methods

- (void)test_CacheWithNSLock {
    CacheWithNSLock *cache = [CacheWithNSLock new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithNSRecursiveLock {
    CacheWithNSRecursiveLock *cache = [CacheWithNSRecursiveLock new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithKeywordSynchronized {
    CacheWithKeywordSynchronized *cache = [CacheWithKeywordSynchronized new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithSerialQueue {
    CacheWithSerialQueue *cache = [CacheWithSerialQueue new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithConcurrentQueue {
    CacheWithConcurrentQueue *cache = [CacheWithConcurrentQueue new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithCPPScopedMutex {
    CacheWithCPPScopedMutex *cache = [CacheWithCPPScopedMutex new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithPthread_rwlock {
    CacheWithPthread_rwlock *cache = [CacheWithPthread_rwlock new];
    [self benchmarkWithCache:cache];
}

- (void)test_CacheWithoutLock {
    CacheWithoutLock *cache = [CacheWithoutLock new];
    [self benchmarkWithCache:cache];
}

@end
