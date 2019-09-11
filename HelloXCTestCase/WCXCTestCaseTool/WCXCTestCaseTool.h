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

@end

NS_ASSUME_NONNULL_END
