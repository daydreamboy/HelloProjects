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

@interface DummyClass : NSObject
- (void)doSomething;
@end

@implementation DummyClass

- (void)doSomething {
    NSLog(@"doSomething");
}

- (void)swizzled_doSomething {
    [self swizzled_doSomething];
    NSLog(@"doSomething for swizzling");
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
    
    // Abnormal Case 2: originalSelector not exists
    success = [WCSwizzleTool exchangeIMPWithClass:[DerivedClass class] originalSelector:NSSelectorFromString(@"doSomething2") swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertFalse(success);
}

- (void)test_fastExchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    BOOL success;
    id object;
    
    // #0    0x00007fff2017c4a8 in flushCaches(objc_class*, char const*, bool (objc_class*) block_pointer) ()
    success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertTrue(success);
    
    object = [DummyClass new];
    [object doSomething];
}

@end
