//
//  WCXCTestCaseTool.h
//  HelloXCTestCase
//
//  Created by wesley_chen on 2019/9/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Start of the asychronous task
 */
#define XCTestExpectation_BEGIN \
NSString *description__ = [NSString stringWithFormat:@"%s:%d", __FUNCTION__, __LINE__]; \
XCTestExpectation *expectation__ = [self expectationWithDescription:description__]; \

/**
 End of the asychronous task

 @param timeout the primitive integer of timeout
 */
#define XCTestExpectation_END(timeout) \
[self waitForExpectationsWithTimeout:(timeout) handler:nil];

/**
 Mark the asychronous task fulfilled/finished
 */
#define XCTestExpectation_FULFILL \
[expectation__ fulfill];

@interface WCXCTestCaseTool : NSObject

/**
 Run async task with block

 @param testCase the XCTestCase object. Pass self in the test method
 @param asyncTaskBlock the block to run asynchronous task
 @return YES if operate successfully, or NO if fails
 @see https://github.com/xslim/TKSenTestAsync/blob/master/SenTest%2BAsync.m
 @see https://github.com/AFNetworking/AFNetworking/issues/466
 
 @code
 
 [WCXCTestCaseTool runAsyncTaskWithXCTestCase:self asyncTaskBlock:^{
    [XXX someAsyncAPIWithBlock:^{
        [WCXCTestCaseTool signalAsyncBlockCompletedXCTestCase:self completionBlock:^{
             // check result of the async task
        }];
    }];
 }];
 
 @endcode
 */
+ (BOOL)runAsyncTaskWithXCTestCase:(XCTestCase *)testCase asyncTaskBlock:(void (^)(void))asyncTaskBlock;

/**
 Signal the async task done

 @param testCase the XCTestCase object. Pass self in the test method
 @param completionBlock the completion block to check result
 @return YES if operate successfully, or NO if fails
 @discussion This method in company with +[WCXCTestCaseTool runAsyncTaskWithXCTestCase:asyncTaskBlock:]
 */
+ (BOOL)signalAsyncBlockCompletedXCTestCase:(XCTestCase *)testCase completionBlock:(void (^)(void))completionBlock;

#pragma mark - Timing Measure

/**
 Measure average time with the count
 
 @param count the iteration count
 @param block the one pass execution
 
 @return YES if parameters are correct, or return NO if wrong.
 */
+ (BOOL)timingMesaureAverageWithCount:(NSUInteger)count block:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
