//
//  Tests_WCThreadTool.m
//  Tests
//
//  Created by wesley_chen on 2020/5/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCThreadTool.h"
#import "WCXCTestCaseTool.h"

@interface Tests_WCThreadTool : XCTestCase

@end

@implementation Tests_WCThreadTool

- (void)test_recursiveCallWithIterateBlock_completionBlock {
    XCTestExpectation_BEGIN
    
    [WCThreadTool recursiveCallWithIterateBlock:^(NSMutableArray *container, NSUInteger iterateCount, WCThreadTool_shouldContinueBlockType shouldContinueBlock) {
        
        NSMutableDictionary *paramM = [NSMutableDictionary dictionary];
        paramM[@"pageIndex"] = @(iterateCount);
        [self requestWithParameter:paramM completion:^(NSString *data, NSError *error) {
            NSLog(@"once request: %@, error: %@", data, error);
            if (error) {
                !shouldContinueBlock ?: shouldContinueBlock(container, error, NO);
            }
            else {
                [container addObject:data];
                !shouldContinueBlock ?: shouldContinueBlock(container, nil, YES);
            }
        }];
    } completionBlock:^(NSMutableArray *container, NSError *error, NSUInteger iterateCount) {
        NSLog(@"iterateCount: %ld, error: %@, container: %@", (long)iterateCount, error, container);
        XCTestExpectation_FULFILL
    }];
    
    XCTestExpectation_END(60 * 5)
}

#pragma mark - Dummy Methods

- (void)requestWithParameter:(NSDictionary *)parameter completion:(void (^)(NSString *data, NSError *error))completion {
    NSTimeInterval sleepInSeconds = (int)(arc4random() % 10);
    [NSThread sleepForTimeInterval:sleepInSeconds];

    NSString *string = [NSString stringWithFormat:@"%d", (int)sleepInSeconds];
    if (sleepInSeconds == 0) {
        NSError *error = [NSError errorWithDomain:@"" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"sleepInSeconds == 0" }];
        completion(string, error);
    }
    else {
        completion(string, nil);
    }
}

@end
