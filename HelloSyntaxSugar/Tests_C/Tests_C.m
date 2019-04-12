//
//  Tests_C.m
//  Tests_C
//
//  Created by wesley_chen on 2019/3/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef struct StructTypeA {
    int field1;
    float field2;
} a;

@interface Tests_C : XCTestCase

@end

@implementation Tests_C

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_struct_array {
    struct StructTypeA *listPtr;
    
    // Case 1
    listPtr = (struct StructTypeA []) {
        10,
        3.14,
        {
            0,
            0
        }
    };
    
    while (listPtr && listPtr->field1) {
        printf("listPtr->field1: %d, listPtr->field2: %f\n", listPtr->field1, listPtr->field2);
        listPtr++;
    }
    printf("----------------------------\n");
    
    
    // Case 2
    listPtr = (struct StructTypeA []) {
        {
            10,
            3.14,
        },
        {
            0,
            0
        }
    };
    
    while (listPtr && listPtr->field1) {
        printf("listPtr->field1: %d, listPtr->field2: %f\n", listPtr->field1, listPtr->field2);
        listPtr++;
    }
    printf("----------------------------\n");
    
    // Case 3
    listPtr = (struct StructTypeA []) {
        10,
        3.14,
        0,
        0
    };
    
    while (listPtr && listPtr->field1) {
        printf("listPtr->field1: %d, listPtr->field2: %f\n", listPtr->field1, listPtr->field2);
        listPtr++;
    }
    printf("----------------------------\n");
}

@end
