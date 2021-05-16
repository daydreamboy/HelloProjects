//
//  Tests_objc_subclassing_restricted.m
//  Tests_OC
//
//  Created by wesley_chen on 2020/12/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

// Note: uncomment the following line
//__attribute__((objc_subclassing_restricted))
@interface ClassNotSuppoertInheritance : NSObject
@end
@implementation ClassNotSuppoertInheritance
@end

@interface DerivedFromClassNotSuppoertInheritance : ClassNotSuppoertInheritance
@end
@implementation DerivedFromClassNotSuppoertInheritance
@end

@interface Tests_objc_subclassing_restricted : XCTestCase
@end

@implementation Tests_objc_subclassing_restricted

- (void)setUp {
}

- (void)tearDown {
}

@end
