//
//  Test_IMP.m
//  Test_OC
//
//  Created by wesley_chen on 2019/6/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface Test_IMP : XCTestCase

@end

@implementation Test_IMP

- (void)test:(NSInteger)arg {
    printf("test called\n");
}

- (void)test_check_IMP {
    IMP imp;
    
    // Case 1
    imp = class_getMethodImplementation([Test_IMP class], @selector(test:));
    imp();
    
    // Case 2
    typeof(self) object = [[[self class] alloc] init];
    void (*func)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger))imp;
    func(object, @selector(test:), 5);
}

@end
