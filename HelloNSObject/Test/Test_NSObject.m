//
//  Tests_NSObject.m
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KeyedSubscriptingObject.h"
#import "IndexedSubscriptingObject.h"

#import <malloc/malloc.h>
#import <objc/runtime.h>

// NSObject declares Class isa as an ivar
@interface Derived : NSObject
{
    // placed a isa pointer ahead here which occupies 8 bytes in 64-bits system
@public // By default, ivars are @protected
    short a;    // 2 bytes
    // here padding two bytes after a
    int b;      // 4 bytes
}
@end
@implementation Derived @end

@interface Tests_NSObject : XCTestCase

@end

@implementation Tests_NSObject

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_keyedSubscript {
    id output;
    KeyedSubscriptingObject<NSString *, NSString *> *map = [KeyedSubscriptingObject new];
    
    // Case 1
    map[@"key"] = @"value";
    output = map[@"key"];
    XCTAssertEqualObjects(output, @"value");
    
    // Case 2
    map[@"key"] = nil;
    output = map[@"key"];
    XCTAssertNil(output);
}

- (void)test_indexedSubscript {
    id output;
    IndexedSubscriptingObject<NSString *> *list = [IndexedSubscriptingObject new];
    
    // Case 1
    list[1] = @"value";
    output = list[1];
    XCTAssertEqualObjects(output, @"value");
    output = list[0];
    XCTAssertNil(output);
    
    // Case 2
    list[1] = nil;
    output = list[1];
    XCTAssertNil(output);
    output = list[0];
    XCTAssertNil(output);
}

- (void)test_isa {
    // Example 1: get size of NSObject object
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"size(NSObject object): %ld", malloc_size((__bridge const void *)obj));
    NSData *objData = [NSData dataWithBytes:(__bridge const void *)(obj) length:malloc_size((__bridge const void *)(obj))];
    NSLog(@"NSObject object contains %@", objData);
    
    // Example 2: Check isa pointer
    NSLog(@"isa: %p", [obj class]);
    NSLog(@"size(isa): %lu", sizeof([obj class]));
    
    NSLog(@"---------------------------");
    
    // Example 3: get size of Derived object
    Derived *empty = [[Derived alloc] init];
    // access @public ivar by pointer
    empty->a = 0x1234;      // assign 2 bytes for short type
    empty->b = 0x12345678;  // assign 4 bytes for int type
    NSLog(@"size(Derived object): %ld", malloc_size((__bridge const void *)empty));
    objData = [NSData dataWithBytes:(__bridge const void *)(empty) length:malloc_size((__bridge const void *)(empty))];
    NSLog(@"Derived object contains %@", objData);
}

- (void)test_hash {
    NSObject *object = [[NSObject alloc] init];
    NSLog(@"%p", object);
    NSLog(@"%lx", (unsigned long)[object hash]);
    NSString *address = [NSString stringWithFormat:@"%p", object];
    NSString *hash = [NSString stringWithFormat:@"0x%lx", (unsigned long)[object hash]];
    XCTAssertEqualObjects(address, hash);
}

- (void)test_NSValue {
    [self performSelector:@selector(setSize:) withObject:[NSValue valueWithCGSize:CGSizeMake(100, 200)]];
}

#pragma mark - 

- (void)setSize:(CGSize)size {
    NSLog(@"%@", NSStringFromCGSize(size));
}

@end
