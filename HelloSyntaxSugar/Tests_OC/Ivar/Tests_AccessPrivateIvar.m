//
//  Tests_AccessPrivateIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AccessPrivateIvar1 : NSObject {
@private
    NSString *_privateIvar;
}
@end
@implementation AccessPrivateIvar1
@end

@interface AccessPrivateIvar2 : AccessPrivateIvar1
@end
@implementation AccessPrivateIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        //_privateIvar = @"abc"; // Compile Error: Instance variable '_privateIvar' is private
    }
    return self;
}
@end

@interface Tests_AccessPrivateIvar : XCTestCase
@end

@implementation Tests_AccessPrivateIvar

- (void)test_access_private_ivar {
    __unused AccessPrivateIvar2 *object = [AccessPrivateIvar2 new];
    //NSLog(@"%@", object->_privateIvar);  // Compile Error: Instance variable '_privateIvar' is private
}

@end
