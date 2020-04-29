//
//  Test_NSObject_WCDebug.m
//  Test
//
//  Created by wesley_chen on 2020/4/29.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+WCDebug.h"

@interface Test_NSObject_WCDebug : XCTestCase

@end

@implementation Test_NSObject_WCDebug

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test222 {
    VAR_DEFINED_DEBUGGABLE(aString, NSString *, @"23123");
    NSLog(@"%@", aString.WCDebugVariableName);
}

@end
