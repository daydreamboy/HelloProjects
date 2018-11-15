//
//  UseDeallocatedMemoryViewController.m
//  HelloXcode_AddressSanitizer
//
//  Created by wesley_chen on 2018/11/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseDeallocatedMemoryViewController.h"
#import "MyClass.h"

@interface UseDeallocatedMemoryViewController ()

@end

@implementation UseDeallocatedMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self test_access_dealloced_memory_case1];
    [self test_access_dealloced_memory_case2];
}

#pragma mark - Test Methods

// Case 1: Use of Deallocated Memory in Objective-C
- (void)test_access_dealloced_memory_case1 {
    __unsafe_unretained MyClass *unsafePointer;
    @autoreleasepool {
        MyClass *object = [MyClass new];
        unsafePointer = object;
    }
    NSLog(@"%d", unsafePointer->instanceVariable);
    // Error: unsafePointer is deallocated in autorelease pool
}

// Case 2: Use of Deallocated Pointer in Objective-C
- (void)test_access_dealloced_memory_case2 {
    int *unsafePointer;
    @autoreleasepool {
        MyClass *object = [MyClass new];
        unsafePointer = &object->instanceVariable;
    }
    NSLog(@"%d", *unsafePointer);
    // Error: unsafePointer is invalidated when object is deallocated in autorelease pool
}

@end
