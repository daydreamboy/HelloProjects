//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/2/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Person: NSObject
@property (nonatomic, copy) NSString *name;
@end

@implementation Person

@end

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_valueForKeyPath_self {
    Person *p = [Person new];
    p.name = @"John";
    
    NSString *name = [p valueForKeyPath:@"self.name"];
    NSLog(@"%@", name);
}

@end
