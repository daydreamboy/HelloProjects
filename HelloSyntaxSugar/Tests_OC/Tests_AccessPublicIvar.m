//
//  Tests_AccessPublicIvar.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

@interface BaseClass2 : NSObject {
    NSInteger _number;
}
@property (nonatomic, assign) NSInteger number;
@end
@implementation BaseClass2
- (instancetype)init {
    self = [super init];
    if (self) {
        _number = 3;
        NSLog(@"%@ self.number: %ld", NSStringFromClass([self class]), (long)self.number);
        NSLog(@"%@ _number: %ld", NSStringFromClass([self class]), (long)_number);
    }
    return self;
}
@end

@interface DerivedClass2 : BaseClass2
@end
@implementation DerivedClass2
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


@interface Tests_AccessPublicIvar : XCTestCase
@end

@implementation Tests_AccessPublicIvar

- (void)test_ivar {
    DerivedClass2 *derivedObject = [DerivedClass2 new];
    NSLog(@"%ld", (long)derivedObject.number);
    XCTAssertTrue(derivedObject.number == 10);
}

@end
