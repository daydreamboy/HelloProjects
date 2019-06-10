//
//  Tests_WCThreadSafeDictionary.m
//  Tests
//
//  Created by wesley_chen on 2019/6/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCThreadSafeDictionary.h"

#define ITERATIONS 10000

@interface Tests_WCThreadSafeDictionary : XCTestCase

@end

@implementation Tests_WCThreadSafeDictionary

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)benchmarkWithCache:(WCThreadSafeDictionary *)cache {
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
            [cache setObject:(__bridge const void * _Nullable)(values[i]) forKey:(__bridge const void * _Nonnull)(keys[i])];
        });
    }
    
    for (int i = 0; i < ITERATIONS; i++) {
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            object = [cache objectForKey:(__bridge const void * _Nonnull)(keys[i])];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ns", @(ITERATIONS), ((endTime - startTime) * 1000000));
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        NSInteger index = [keys indexOfObject:key];
        
        NSString *string = [cache objectForKey:(__bridge const void * _Nonnull)(key)];
        XCTAssert([values[index] isEqualToString:string]);
    }
}

#pragma mark - Test Methods

- (void)test_1 {
    WCThreadSafeDictionary *cache = [WCThreadSafeDictionary dictionary];
    [self benchmarkWithCache:cache];
}

@end
