//
//  Test_WCSwizzleTool.m
//  Test
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCSwizzleTool.h"

@interface BaseClass : NSObject
- (void)doSomething;
@end

@implementation BaseClass
- (void)doSomething {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
@end

@interface DerivedClass: NSObject
@end

@implementation DerivedClass
- (void)swizzled_doSomething {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
@end

@interface Test_WCSwizzleTool : XCTestCase

@end

@implementation Test_WCSwizzleTool

- (void)test_exchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    BOOL success;
    
    // Abnormal Case 1: derived class has method, but its super class has one
    success = [WCSwizzleTool exchangeIMPWithClass:[DerivedClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertFalse(success);
}

@end
