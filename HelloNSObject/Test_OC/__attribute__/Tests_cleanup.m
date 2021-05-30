//
//  Tests_cleanup.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/19.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

static void stringCleanUp(__strong NSString **string) {
    NSLog(@"stringCleanUp: %@", *string);
}

void objectCleanup(id *object) {
    NSLog(@"objectCleanUp: %@", *object);
}

@interface Tests_cleanup_Object : NSObject
@end

@implementation Tests_cleanup_Object
- (void)dealloc {
    NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
}
@end

#pragma mark -

@interface Tests_cleanup : XCTestCase
@end

@implementation Tests_cleanup

- (void)test_cleanup {
    {
        __unused NSString *string __attribute__((cleanup(stringCleanUp))) = @"local variable";
    } // Note: the string variable will be destroyed and will trigger cleanup callback
}

- (void)test_cleanup_object {
    {
        __unused Tests_cleanup_Object *object __attribute__((cleanup(objectCleanup))) = [Tests_cleanup_Object new];
        NSLog(@"%@", object);
    } // Note: the cleanup callback called prior to the dealloc method
}

- (void)test_cleanup_multiple {
    {
        __unused Tests_cleanup_Object *object1 __attribute__((cleanup(objectCleanup))) = [Tests_cleanup_Object new];
        NSLog(@"object1: %@", object1);
        
        __unused Tests_cleanup_Object *object2 __attribute__((cleanup(objectCleanup))) = [Tests_cleanup_Object new];
        NSLog(@"object2: %@", object2);
        
        __unused Tests_cleanup_Object *object3 __attribute__((cleanup(objectCleanup))) = [Tests_cleanup_Object new];
        NSLog(@"object3: %@", object3);
    } // Note: the cleanup callback function calling order is object3 - object2 - object1
}

@end
