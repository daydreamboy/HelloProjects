//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/5/24.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WCGCDTool.h"
#import "LoremIpsum.h"
#import "WCXCTestCaseTool.h"
#import "File.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_safeDispatchGroupEnterLeavePairWithGroupTaskInfo_runTaskBlock_allTaskCompletionBlock {
    NSUInteger count = 100;
    
    XCTestExpectation_BEGIN;
    
    WCGCDGroupTaskInfo *groupTaskInfo = [WCGCDGroupTaskInfo new];
    groupTaskInfo.taskQueue = dispatch_queue_create("com.wc.concurrent", DISPATCH_QUEUE_CONCURRENT);
    groupTaskInfo.completionQueue = dispatch_queue_create("com.wc.completion", DISPATCH_QUEUE_SERIAL);
    groupTaskInfo.dataArray = [self createTestDataWithCount:count];
    
    [WCGCDTool safeDispatchGroupEnterLeavePairWithGroupTaskInfo:groupTaskInfo runTaskBlock:^(id  _Nonnull data, NSUInteger index, void (^ _Nonnull taskBlockFinished)(id _Nonnull, NSError * _Nullable)) {
        File *file = data;
        
        NSError *error = nil;
        file.name = [NSString stringWithFormat:@"test_%d.txt", (int)index];
        file.path = [NSTemporaryDirectory() stringByAppendingPathComponent:file.name];
        BOOL success = [file.content writeToFile:file.path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (!success) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
            file.path = nil;
#pragma GCC diagnostic pop
            
            XCTAssertTrue(NO, "should nevet hit this line");
        }
        
        [NSThread sleepForTimeInterval:((arc4random() % 1000) / 1000.0)];
        
        taskBlockFinished(file, error);
        
        // Note: call taskBlockFinished twice will take no effect
        taskBlockFinished(file, error);
        
    } allTaskCompletionBlock:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull errorArray) {
        XCTAssertTrue(dataArray.count == count);
        for (id error in errorArray) {
            XCTAssertTrue(error == [NSNull null]);
        }
        
        for (NSInteger i = 0; i < dataArray.count; i++) {
            NSString *fileName = [NSString stringWithFormat:@"test_%d.txt", (int)i];
            
            File *file = dataArray[i];
            XCTAssertEqualObjects(file.name, fileName);
        }
        
        XCTestExpectation_FULFILL;
    }];
    
    XCTestExpectation_END(1000);
}

#pragma mark ::

- (NSArray *)createTestDataWithCount:(NSUInteger)count {
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        File *file = [File new];
        file.content = [[NSString stringWithFormat:@"content of test_%d\n", (int)i] stringByAppendingString:[LoremIpsum paragraphsWithNumber:(arc4random() % 100) + 1]];
        
        [arrM addObject:file];
    }
    
    return arrM;
}

#pragma mark ::

- (void)test_performAsyncTaskSynchronously_timeout {
    BOOL output;
    
    // Case 1
    output = [WCGCDTool performSynchronouslyWithAsyncTask:^(WCGCDToolAsyncTaskSynchronizedCompletion  _Nonnull completion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(3);
            BOOL finished = YES;
            if (finished) {
                completion(YES);
            }
            else {
                completion(NO);
            }
        });
    } timeout:DISPATCH_TIME_FOREVER];

    // continue to process
    NSLog(@"output: %@", output ? @"YES" : @"NO");
    XCTAssertTrue(output);

    // Case 2: call completion directly with YES
    output = [WCGCDTool performSynchronouslyWithAsyncTask:^(WCGCDToolAsyncTaskSynchronizedCompletion  _Nonnull completion) {
        BOOL finished = YES;
        if (finished) {
            completion(YES);
        }
        else {
            completion(NO);
        }
    } timeout:DISPATCH_TIME_FOREVER];

    // continue to process
    NSLog(@"output: %@", output ? @"YES" : @"NO");
    XCTAssertTrue(output);
    
    // Case 3: call completion directly with NO
    output = [WCGCDTool performSynchronouslyWithAsyncTask:^(WCGCDToolAsyncTaskSynchronizedCompletion  _Nonnull completion) {
        BOOL finished = NO;
        if (finished) {
            completion(YES);
        }
        else {
            completion(NO);
        }
    } timeout:DISPATCH_TIME_FOREVER];

    // continue to process
    NSLog(@"output: %@", output ? @"YES" : @"NO");
    XCTAssertFalse(output);
    
    // Case 4
    output = [WCGCDTool performSynchronouslyWithAsyncTask:^(WCGCDToolAsyncTaskSynchronizedCompletion  _Nonnull completion) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(5);
            BOOL finished = YES;
            if (finished) {
                completion(YES);
            }
            else {
                completion(NO);
            }
        });
    } timeout:DISPATCH_TIME_IN_SEC(1)];

    // continue to process
    NSLog(@"output: %@", output ? @"YES" : @"NO");
    XCTAssertFalse(output);
    
    // Abnormal Case 1: pass nil task
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    output = [WCGCDTool performSynchronouslyWithAsyncTask:nil timeout:DISPATCH_TIME_FOREVER];
#pragma GCC diagnostic pop
    
    // continue to process
    NSLog(@"output: %@", output ? @"YES" : @"NO");
    XCTAssertFalse(output);
}

@end
