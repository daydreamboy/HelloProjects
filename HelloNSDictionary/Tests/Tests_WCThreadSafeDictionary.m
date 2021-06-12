//
//  Tests_WCThreadSafeDictionary.m
//  Tests
//
//  Created by wesley_chen on 2019/6/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCThreadSafeDictionary.h"
#import "MyKey.h"
#import "MyValue.h"
#import "WCXCTestCaseTool.h"

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

- (void)benchmarkWithCache:(WCThreadSafeDictionary<NSString *, NSString *> *)cache {
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
            cache[keys[i]] = values[i];
        });
    }
    
    for (int i = 0; i < ITERATIONS; i++) {
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            object = cache[keys[i]];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ms", @(ITERATIONS), ((endTime - startTime) * 1000));
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        NSInteger index = [keys indexOfObject:key];
        
        NSString *string = cache[key];
        XCTAssert([values[index] isEqualToString:string]);
    }
}

- (void)benchmarkForFastEnumerationWithCache:(WCThreadSafeDictionary<NSString *, NSString *> *)cache {
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
            cache[keys[i]] = values[i];
        });
    }
    
    for (int i = 0; i < ITERATIONS; i++) {
        __block id object;
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            object = cache[keys[i]];
        });
    }
    
    for (int i = 0; i < 10; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            for (NSString *key in cache) {
                NSLog(@"%@ = %@", key, cache[key]);
                NSString *index1 = [key stringByReplacingOccurrencesOfString:@"key" withString:@""];
                NSString *index2 = [cache[key] stringByReplacingOccurrencesOfString:@"value" withString:@""];
                XCTAssertEqualObjects(index1, index2);
            }
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ms", @(ITERATIONS), ((endTime - startTime) * 1000));
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        NSInteger index = [keys indexOfObject:key];
        
        NSString *string = cache[key];
        XCTAssert([values[index] isEqualToString:string]);
    }
}

#pragma mark - Test Methods

- (void)test_thread_safe {
    WCThreadSafeDictionary<NSString *, NSString *> *cache = [WCThreadSafeDictionary dictionary];
    [self benchmarkWithCache:cache];
}

- (void)test_thread_safe_fast_enumeration {
    WCThreadSafeDictionary<NSString *, NSString *> *cache = [WCThreadSafeDictionary dictionary];
    [self benchmarkForFastEnumerationWithCache:cache];
}

- (void)test_fast_enumeration {
    WCThreadSafeDictionary<NSString *, NSString *> *dict = [WCThreadSafeDictionary dictionary];
    dict[@"1"] = @"A";
    dict[@"2"] = @"B";
    dict[@"3"] = @"C";
    for (NSString *key in dict) {
        NSString *value = dict[key];
        NSLog(@"%@", value);
    }
}

- (void)test_allKeys {
    WCThreadSafeDictionary<NSString *, NSString *> *cache = [WCThreadSafeDictionary dictionary];
    
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
            cache[keys[i]] = values[i];
        });
    }
    
    for (NSString *key in [cache allKeys]) {
        NSLog(@"%@", key);
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for %@ iterations: %g ms", @(ITERATIONS), ((endTime - startTime) * 1000));
}

- (void)test_allKeys_memory {
    WCThreadSafeDictionary<NSString *, NSString *> *cache = [WCThreadSafeDictionary dictionary];
    
    __block __weak id weakKey = nil;
    __block __weak id weakValue = nil;
    {
        NSString *key = [[NSString alloc] initWithFormat:@"%@", @"this string must be very long long long"];
        NSString *value = [[NSString alloc] initWithFormat:@"%@", @"this string must be very long long long"];
        XCTAssertEqualObjects(NSStringFromClass([key class]), @"__NSCFString");
        XCTAssertEqualObjects(NSStringFromClass([value class]), @"__NSCFString");
        
        weakKey = key;
        weakValue = value;
        
        cache[key] = value;
        
        NSString *firstKey = [[cache allKeys] firstObject];
        [cache removeObjectForKey:firstKey];
    }
    
    XCTestExpectation_BEGIN
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertNotNil(weakKey);
        XCTAssertNil(weakValue);
        
        XCTestExpectation_FULFILL
    });
    
    XCTestExpectation_END(10)
}


@end
