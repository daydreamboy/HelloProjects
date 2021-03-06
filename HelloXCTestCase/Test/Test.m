//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2019/9/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCXCTestCaseTool.h"

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

/**
 *  Demonstrate the problem of test asynchronous network
 */
- (void)test_sendAsynchronousRequest {
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *responseString = [[NSString alloc] initWithData:data
                                                         encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString); // Error: Will not output here
    }];
#pragma GCC diagnostic pop
}

/**
 *  Example of runTestWithAsyncBlock: and asyncBlockCompletedWithBlock:
 */
- (void)test_runTestWithAsyncBlock_and_asyncBlockCompletedWithBlock {
    
    weakify(self);
    [WCXCTestCaseTool runAsyncTaskWithXCTestCase:self asyncTaskBlock:^{
        NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/"];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                                 cachePolicy:NSURLRequestReloadIgnoringCacheData
                                             timeoutInterval:30];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   strongifyWithReturn(self, return);
                                   
                                   [WCXCTestCaseTool signalAsyncBlockCompletedXCTestCase:self completionBlock:^{
                                       NSString *responseString = [[NSString alloc] initWithData:data
                                                                                        encoding:NSUTF8StringEncoding];
                                       NSLog(@"%@", responseString);
                                   }];
                               }];
#pragma GCC diagnostic pop
    }];
}

- (void)test_XCTestExpectation {
    XCTestExpectation_BEGIN
    
    NSURL *URL = [NSURL URLWithString:@"https://www.baidu.com/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL
                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                         timeoutInterval:30];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSString *responseString = [[NSString alloc] initWithData:data
                                                                                encoding:NSUTF8StringEncoding];
                               NSLog(@"%@", responseString);
                               
                               XCTestExpectation_FULFILL;
                           }];
#pragma GCC diagnostic pop
    
    XCTestExpectation_END(40);
}

- (void)test_measureBlock {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test_timingMesaureAverageWithCount_block {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < 1000; i++) {
        dict[[NSString stringWithFormat:@"%d", (int)i]] = @(i);
    }
    
    NSUInteger count = 1000;
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:count block:^{
        __unused NSString *JSONString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    }];
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:count block:^{
        __unused NSString *compactDescription = [[[dict description] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    }];
}

@end
