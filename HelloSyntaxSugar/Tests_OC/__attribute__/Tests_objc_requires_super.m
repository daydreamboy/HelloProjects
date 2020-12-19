//
//  Tests_objc_requires_super.m
//  Tests_OC
//
//  Created by wesley_chen on 2020/12/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_objc_requires_super_BaseClass : NSObject
- (void)aMethodNeedCallSuperWhenOverride __attribute__((objc_requires_super));
@end
@implementation Tests_objc_requires_super_BaseClass
- (void)aMethodNeedCallSuperWhenOverride {
}
@end

@interface Tests_objc_requires_super_DerivedClass : Tests_objc_requires_super_BaseClass
@end
@implementation Tests_objc_requires_super_DerivedClass
- (void)aMethodNeedCallSuperWhenOverride {
    // Note: a warning here if not call [super aMethodNeedCallSuperWhenOverride]
}
@end

@interface Tests_objc_requires_super : XCTestCase
@end

@implementation Tests_objc_requires_super

- (void)setUp {
}

- (void)tearDown {
}

@end
