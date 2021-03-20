//
//  Test_WCSwizzleTool.m
//  Test
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCSwizzleTool.h"
#import "WCXCTestCaseTool.h"

@interface WCSwizzleTool_BaseClass : NSObject
- (NSString *)doSomething;
@end

@implementation WCSwizzleTool_BaseClass
- (NSString *)doSomething {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
    return @"doSomething";
}
@end

@interface WCSwizzleTool_DerivedClass: WCSwizzleTool_BaseClass
@end

@implementation WCSwizzleTool_DerivedClass
- (NSString *)swizzled_doSomething {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
    
    return @"doSomething for swizzling";
}
@end

@interface DummyClass : NSObject
- (NSString *)doSomething;
@end

@implementation DummyClass

#pragma mark - Swizzle instance methods

- (NSString *)doSomething {
    NSLog(@"doSomething");
    return @"doSomething";
}

- (NSString *)swizzled_doSomething {
    NSLog(@"doSomething for swizzling");
    
    return [NSString stringWithFormat:@"%@ for swizzling", [self swizzled_doSomething]];
}

#pragma mark - Swizzle class methods

+ (NSString *)doSomething {
    NSLog(@"doSomething2");
    return @"doSomething2";
}

+ (NSString *)swizzled_doSomething {
    NSLog(@"doSomething for swizzling2");
    
    return [NSString stringWithFormat:@"%@ for swizzling2", [self swizzled_doSomething]];
}

@end

@interface Test_WCSwizzleTool : XCTestCase

@end

@implementation Test_WCSwizzleTool

- (void)test_exchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    BOOL success;
    WCSwizzleTool_DerivedClass *object;
    id output;
    
    // Case 1: derived class has method, but its super class has one
    success = [WCSwizzleTool exchangeIMPWithClass:[WCSwizzleTool_DerivedClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertTrue(success);
    
    object = [WCSwizzleTool_DerivedClass new];
    output =[object doSomething];
    XCTAssertEqualObjects(output, @"doSomething for swizzling");
    
    // Abnormal Case 2: originalSelector not exists
    success = [WCSwizzleTool exchangeIMPWithClass:[WCSwizzleTool_DerivedClass class] originalSelector:NSSelectorFromString(@"doSomething2") swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertFalse(success);
}

- (void)test_case_swizzle_twice_fastExchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    BOOL success;
    DummyClass *object;
    id output;
    
    object = [DummyClass new];
    success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
    XCTAssertTrue(success);
    output = [object doSomething];
    XCTAssertEqualObjects(output, @"doSomething for swizzling");
    
    success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(swizzled_doSomething) swizzledSelector:@selector(doSomething) forClassMethod:NO];
    XCTAssertTrue(success);
    
    output = [object doSomething];
    XCTAssertEqualObjects(output, @"doSomething");
}

- (void)test_case_swizzle_class_methods_fastExchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    BOOL success;
    id output;
    
    success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:YES];
    XCTAssertTrue(success);
    output = [DummyClass doSomething];
    XCTAssertEqualObjects(output, @"doSomething2 for swizzling2");
    
    success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(swizzled_doSomething) swizzledSelector:@selector(doSomething) forClassMethod:YES];
    XCTAssertTrue(success);
    
    output = [DummyClass doSomething];
    XCTAssertEqualObjects(output, @"doSomething2");
}

- (void)test_time_cost_exchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    __block BOOL success;
    [WCXCTestCaseTool timingMesaureAverageWithCount:10000 block:^{
        success = [WCSwizzleTool exchangeIMPWithClass:[DummyClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
        XCTAssertTrue(success);
    }];
}

- (void)test_time_cost_fastExchangeIMPWithClass_originalSelector_swizzledSelector_forClassMethod {
    __block BOOL success;
    [WCXCTestCaseTool timingMesaureAverageWithCount:10000 block:^{
        success = [WCSwizzleTool fastExchangeIMPWithClass:[DummyClass class] originalSelector:@selector(doSomething) swizzledSelector:@selector(swizzled_doSomething) forClassMethod:NO];
        XCTAssertTrue(success);
    }];
}

@end
