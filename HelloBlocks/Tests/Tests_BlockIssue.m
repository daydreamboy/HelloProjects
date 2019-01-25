//
//  Tests_BlockIssue.m
//  Tests
//
//  Created by wesley_chen on 2019/1/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface MyObject : NSObject
@property (nonatomic, copy) void (^block)(void);
@end

@implementation MyObject

- (void)dealloc {
    NSLog(@"deallocating %@", self);
}

@end

@interface Tests_BlockIssue : XCTestCase

@end

@implementation Tests_BlockIssue

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_block_nil_crash {
    __weak MyObject *weak_object;
    {
        MyObject *object;
        object = [MyObject new];
        object.block = ^{
            NSLog(@"object");
        };
        weak_object = object;
    }
    
    weak_object.block(); // Crash
}

- (void)test_block_nil_crash_fixed {
    __weak MyObject *weak_object;
    {
        MyObject *object;
        object = [MyObject new];
        object.block = ^{
            NSLog(@"object");
        };
        weak_object = object;
    }
    
    if (weak_object.block) {
        weak_object.block();
    }
    else {
        NSLog(@"weak_object.block is nil");
    }
}

@end
