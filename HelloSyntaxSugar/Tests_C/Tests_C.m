//
//  Tests_C.m
//  Tests_C
//
//  Created by wesley_chen on 2019/3/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCTuple.h"

#include <execinfo.h>
#include <stdio.h>
#include <stdlib.h>

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

- (void)test_goto {
    int d = 1;
    
    do {
        int a = 1;
        int b = 3;
        if (a == 1) {
            if (b != 2) {
                goto defaultCase;
            }
            break; // Note: if b == 2, skip the default case
        }
        else if (a == 2) {
            if (b != 3) {
                goto defaultCase;
            }
            break; // Note: if b == 3, skip the default case
        }
        defaultCase: {
            int c = 4; // Note: declare variable must in the code block when using goto label
            printf("%d\n", c);
            d += c;
        }
    } while (0);
    
    XCTAssertTrue(d == 5);
}

- (void)test_tuple {
}

//- (id)methodWithReturnTuple {
//    return Tuple(@1, @"string", 2);
//}

- (void)test_strlen {
    NSString *stringMaybeNil = nil;
    
    size_t len = strlen([stringMaybeNil UTF8String]); // Crash: pass NULL to strlen
    printf("%zu\n", len);
}

void
print_trace (void)
{
  void *array[10];
  char **strings;
  int size, i;

  size = backtrace (array, 10);
  strings = backtrace_symbols (array, size);
  if (strings != NULL)
  {

    printf ("Obtained %d stack frames.\n", size);
    for (i = 0; i < size; i++)
      printf ("%s\n", strings[i]);
  }

  free (strings);
}


void myFunction()
{
    // Note: get c function address at runtime
    void *myImplementation = myFunction;
    printf("%p\n", myImplementation);
    /*
    void (*p)(void) = myImplementation;
    p();
     */
    
    print_trace();
}

- (void)test_c_function_pointer {
    myFunction();
}

@end
