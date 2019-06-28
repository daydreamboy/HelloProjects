//
//  Tests_AccessIvarOfExtension.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "BaseClass3.h"
#import "BaseClass3_Internal.h"

@interface DerivedClass3 : BaseClass3
@end
@implementation DerivedClass3
- (instancetype)init {
    self = [super init];
    if (self) {
        _number = 10;
        NSLog(@"%@ self.number: %ld", NSStringFromClass([self class]), (long)self.number);
        NSLog(@"%@ _number: %ld", NSStringFromClass([self class]), (long)_number);
    }
    return self;
}
@end

@interface Tests_AccessIvarOfExtension : XCTestCase

@end

@implementation Tests_AccessIvarOfExtension

- (void)test_ivar {
    DerivedClass3 *derivedObject = [DerivedClass3 new];
    NSLog(@"%ld", (long)derivedObject.number);
    XCTAssertTrue(derivedObject.number == 10);
}

@end
