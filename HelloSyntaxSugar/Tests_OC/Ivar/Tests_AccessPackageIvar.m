//
//  Tests_AccessPackageIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/5/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <StaticLibrary/StaticLibrary.h>
#import <DynamicFramework/DynamicFramework.h>

@interface AccessPackageIvar1 : NSObject {
@package
    NSString *_packageIvar;
}
@end
@implementation AccessPackageIvar1
@end

@interface AccessPackageIvar2 : AccessPackageIvar1
@end
@implementation AccessPackageIvar2
- (instancetype)init {
    self = [super init];
    if (self) {
        _packageIvar = @"abc";
    }
    return self;
}
@end

#pragma mark -

@interface AccessPackageIvarFromDynamicFramework : DynamicFrameworkClass
@end
@implementation AccessPackageIvarFromDynamicFramework
- (instancetype)init {
    self = [super init];
    if (self) {
        /**
         Undefined symbols for architecture x86_64:
         "_OBJC_IVAR_$_DynamicFrameworkClass._packageIvar", referenced from:
             -[AccessPackageIvarFromStaticLibrary init] in Tests_AccessPackageIvar.o
         */
        //_packageIvar = @"123";
        _publicIvar = @"123";
    }
    return self;
}
@end

#pragma mark -

@interface Tests_AccessPackageIvar : XCTestCase
@end

@implementation Tests_AccessPackageIvar

- (void)test_access_package_ivar {
    __unused AccessPackageIvar2 *object = [AccessPackageIvar2 new];
    NSLog(@"%@", object->_packageIvar);
    
    object->_packageIvar = @"123";
    XCTAssertEqualObjects(object->_packageIvar, @"123");
}

- (void)test_access_public_ivar_from_dynamic_framework {
    __unused AccessPackageIvarFromDynamicFramework *object = [AccessPackageIvarFromDynamicFramework new];
    NSLog(@"%@", object->_publicIvar);
    
    object->_publicIvar = @"123";
    XCTAssertEqualObjects(object->_publicIvar, @"123");
}

@end
