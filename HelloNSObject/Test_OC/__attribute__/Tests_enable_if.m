//
//  Tests_enable_if.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef NS_ENUM(NSInteger, MyEnumType) {
    MyEnumTypeA,
    MyEnumTypeB,
};

static NSString *NSStringFromMyEnumType(MyEnumType type) __attribute__((enable_if(type > MyEnumTypeA - 1 && type < MyEnumTypeB + 1, "枚举值不在范围中"))) {
    switch (type) {
        case MyEnumTypeA:
            return @"A";
        case MyEnumTypeB:
            return @"B";
        default:
            break;
    }
    return nil;
}

@interface Tests_enable_if : XCTestCase

@end

@implementation Tests_enable_if

- (void)test_enable_if {
    NSString *string;
    __unused NSInteger type = 200;
    
    string = NSStringFromMyEnumType(MyEnumTypeA);
    string = NSStringFromMyEnumType(MyEnumTypeB);
    
    // Compilation Errors: error: no matching function for call to 'NSStringFromMyEnumType'
    /*
    string = NSStringFromMyEnumType(-1);
    string = NSStringFromMyEnumType(100);
    string = NSStringFromMyEnumType(type);
     */
}

@end
