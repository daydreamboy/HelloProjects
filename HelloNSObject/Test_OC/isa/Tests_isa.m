//
//  Tests_isa.m
//  Test_OC
//
//  Created by wesley_chen on 2021/6/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"

// Mimics the objective-c object stucture for checking if a range of memory is an object.
typedef struct {
    Class isa;
} wc_faked_object_t;

@interface Tests_isa : XCTestCase

@end

@implementation Tests_isa

- (void)test_get_class_pointer_from_isa {
    id object = [Person new];
    
    wc_faked_object_t *tryObject = (__bridge wc_faked_object_t *)object;
    Class tryClass = NULL;
#ifdef __arm64__
    // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
    extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
    tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
    tryClass = tryObject->isa;
#endif
    
    XCTAssertEqualObjects(NSStringFromClass(tryClass), @"Person");
    NSLog(@"%@", NSStringFromClass(tryClass));
}

@end
