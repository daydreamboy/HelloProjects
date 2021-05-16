//
//  Tests_objc_boxable.m
//  Tests_OC
//
//  Created by wesley_chen on 2020/12/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

// Note: make some_struct into objc_boxable
struct __attribute__((objc_boxable)) some_struct {
    int i;
};

// Note: some_union into objc_boxable
union __attribute__((objc_boxable)) some_union {
    int i;
    float f;
};

typedef struct _some_struct some_struct;
typedef struct some_struct some_struct2;

// Note: make existing type into objc_boxable
typedef struct __attribute__((objc_boxable)) CGRect WCRect;

@interface Tests_objc_boxable : XCTestCase

@end

@implementation Tests_objc_boxable

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_objc_boxable {
    struct some_struct a = { 1 };
    NSLog(@"%@", @(a));
    
    union some_union c = { 3.14 };
    NSLog(@"%@", @(c));
}

- (void)test_WCRect {
    NSValue *value;
    CGRect rect;
    
    CGRect rect2 = CGRectMake(0, 0, 100, 100);
    value = @(rect2);
    NSLog(@"%@", value);
    rect = [value CGRectValue];
    NSLog(@"{%f, %f, %f, %f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
    WCRect rect3 = CGRectMake(0, 0, 200, 200);
    value = @(rect3);
    NSLog(@"%@", value);
    rect = [value CGRectValue];
    NSLog(@"{%f, %f, %f, %f}", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
