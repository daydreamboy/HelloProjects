//
//  Tests_AccessPublicIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import <StaticLibrary/StaticLibrary.h>

@interface AccessPublicIvar1 : NSObject {
@public
    NSString *_publicIvar;
}
@end
@implementation AccessPublicIvar1
@end

@interface AccessPublicIvar2 : AccessPublicIvar1
@end
@implementation AccessPublicIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _publicIvar = @"abc";
    }
    return self;
}
@end

#pragma mark -

@interface AccessPublicIvarFromStaticLibrary : StaticLibrary
@end
@implementation AccessPublicIvarFromStaticLibrary
- (instancetype)init {
    self = [super init];
    if (self) {
        _publicIvar = @"abc";
    }
    return self;
}
@end

#pragma mark -

@interface Tests_AccessPrivateIvar : XCTestCase
@end

@interface Tests_AccessPublicIvar : XCTestCase
@end

@implementation Tests_AccessPublicIvar

- (void)test_access_public_ivar {
    __unused AccessPublicIvar2 *object = [AccessPublicIvar2 new];
    NSLog(@"%@", object->_publicIvar);
    
    object->_publicIvar = @"123";
    XCTAssertEqualObjects(object->_publicIvar, @"123");
}

@end
