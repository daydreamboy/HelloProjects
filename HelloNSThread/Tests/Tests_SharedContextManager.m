//
//  Tests_ContextManager.m
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPMSharedContextManager.h"
#import "WrongContextManager.h"

#define ITERATIONS 10000

@interface Tests_ContextManager : XCTestCase

@end

@implementation Tests_ContextManager

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

#pragma mark - Test Methods

- (void)test_MPMSharedContextManager_createSharedContext {
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
            id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][keys[i]];
            context.name = keys[i];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for inserting %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][key];
        XCTAssertEqualObjects(context.name, key);
    }
}

- (void)test_MPMSharedContextManager_useSharedContext {
    NSMutableArray *keys = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    CFTimeInterval startTime;
    CFTimeInterval endTime;
    dispatch_group_t group;
    
    for (int i = 0; i < ITERATIONS; i++) {
        [keys addObject:[NSString stringWithFormat:@"key%d", i]];
        [values addObject:[NSString stringWithFormat:@"value%d", i]];
    }
    
    group = dispatch_group_create();
    
    startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][keys[i]];
            context.name = keys[i];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for creating %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][key];
        XCTAssertEqualObjects(context.name, key);
    }
    
    // Step 2
    
    group = dispatch_group_create();
    
    startTime = CACurrentMediaTime();
    for (int i = 0; i < ITERATIONS; i++) {
        dispatch_group_async(group, dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            
            // Note: let the front 5 contexts to set key/value and append value
            for (NSInteger j = 0; j < 5; j++) {
                id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][keys[j]];
                
                [context setItemWithObject:values[i] forKey:keys[i]];
                [context appendItemWithObject:values[i]]; // Note: append value concurrently, so index not match the value
            }
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for mutating %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
    
    // Check: key/value is correct in the map
    for (int i = 0; i < ITERATIONS; i++) {
        NSString *key = keys[i];
        NSString *value = values[i];
        
        for (NSInteger j = 0; j < 5; j++) {
            id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][keys[j]];
            
            id<MPMContextItem> item = [context itemForKey:key];
            
            NSString *valueInMap = item.object;
            XCTAssertEqualObjects(valueInMap, value);
            XCTAssertTrue(context.allItems.count == ITERATIONS);
        }
    }
    
    // Check: timestamp is increased in the list
    NSTimeInterval lastTimestamps[5] = {0, 0, 0, 0, 0};
    
    for (NSInteger j = 0; j < 5; j++) {
        NSString *key = [NSString stringWithFormat:@"key%d", (int)j];
        id<MPMSharedContext> context = [MPMSharedContextManager sharedInstance][key];
        
        id<MPMContextItem> item = [context itemForKey:key];

        XCTAssertTrue(item.timestamp > lastTimestamps[j]);
        lastTimestamps[j] = item.timestamp;
    }
    
}

#pragma mark - Issue Methods

- (void)test_WrongContextManager_createSharedContext {
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
            id<MPMSharedContext> context = [WrongContextManager sharedInstance][keys[i]];
            context.name = keys[i];
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    CFTimeInterval endTime = CACurrentMediaTime();
    
    NSLog(@"Total time for inserting %@ times: averaged %g ns", @(ITERATIONS), (((endTime - startTime) * 1000000000)) / ITERATIONS);
    
    // Make sure the values were added correctly
    for (NSString *key in keys) {
        id<MPMSharedContext> context = [WrongContextManager sharedInstance][key];
        XCTAssertEqualObjects(context.name, key);
    }
}

@end
