//
//  Tests_AccessProtectedIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AccessProtectedIvar1 : NSObject {
@protected
    NSString *_protectedIvar;
}
@end
@implementation AccessProtectedIvar1
@end

@interface AccessProtectedIvar2 : AccessProtectedIvar1
@end
@implementation AccessProtectedIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _protectedIvar = @"abc";
    }
    return self;
}
@end


@interface Tests_AccessProtectedIvar : XCTestCase
@end

@implementation Tests_AccessProtectedIvar

- (void)test_access_protected_ivar {
    __unused AccessProtectedIvar2 *object = [AccessProtectedIvar2 new];
    //NSLog(@"%@", object->_protectedIvar);  // Compile Error: Instance variable '_protectedIvar' is protected
}

@end
