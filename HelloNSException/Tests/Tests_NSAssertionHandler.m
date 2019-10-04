//
//  Tests_NSAssertionHandler.m
//  Tests
//
//  Created by wesley_chen on 2019/9/24.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSAssertionHandler : XCTestCase

@end

@implementation Tests_NSAssertionHandler

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test_handleFailureInMethod_object_file_lineNumber_description {
    NSString *__assert_file__ = [NSString stringWithUTF8String:__FILE__];
    __assert_file__ = __assert_file__ ? __assert_file__ : @"<Unknown File>";
    [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd object:self file:__assert_file__ lineNumber:__LINE__ description:@"请联系XXX"];
}

@end
