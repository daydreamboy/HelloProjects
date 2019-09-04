//
//  Test_bridge.m
//  Test
//
//  Created by wesley_chen on 2019/6/17.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test_bridge : XCTestCase

@end

@implementation Test_bridge

- (void)test {    
    CFStringRef cfString = CFSTR("hello, world");
    __unsafe_unretained NSString *nsString = (__bridge id)cfString;
}  // Note: make a breakpoint here

@end
