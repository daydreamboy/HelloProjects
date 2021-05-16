//
//  Tests_AccessIvarOfProperty.m
//  Tests_AccessIvarOfProperty
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>

@interface BaseClass1 : NSObject
@property (nonatomic, assign) NSInteger number;
@end
@implementation BaseClass1
- (instancetype)init {
    self = [super init];
    if (self) {
        _number = 3;
    }
    return self;
}
@end

@interface DerivedClass1 : BaseClass1
@end
@implementation DerivedClass1
- (instancetype)init {
    self = [super init];
    if (self) {
       //_number = 10; // Compile Error： Instance variable '_number' is private
    }
    return self;
}
@end

@interface Tests_AccessIvarOfProperty : XCTestCase
@end

@implementation Tests_AccessIvarOfProperty
@end
