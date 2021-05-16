//
//  Tests_Block.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/4/13.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

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


@interface DummyObjectHoldInBlock : NSObject
@end

@implementation DummyObjectHoldInBlock
- (void)dealloc {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
@end

@interface Tests_Block : XCTestCase

@end

@implementation Tests_Block

- (void)test_block_release {
    XCTestExpectation_BEGIN
    
    DummyObjectHoldInBlock *object = [DummyObjectHoldInBlock new];
    void (^block)(void) = ^{
        [object description];
        
        XCTestExpectation_FULFILL
    };
    [self callWithCompletion:block];
    NSLog(@"%p", block);
    
    XCTestExpectation_END(30)
}

- (void)callWithCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        !completion ?: completion();
    });
}

@end
