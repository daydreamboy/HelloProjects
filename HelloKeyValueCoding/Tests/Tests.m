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
    NSString *name;
    
    Person *p = [Person new];
    p.name = @"John";
    
    name = [p valueForKeyPath:@"self.name"];
    XCTAssertEqualObjects(name, @"John");
    
    name = [p valueForKey:@"name"];
    XCTAssertEqualObjects(name, @"John");
}

- (void)test_setValue_forKey_or_setValue_forKeyPath {
    Person *p = [Person new];
    
    [p setValue:@"John" forKey:@"name"];
    XCTAssertEqualObjects(p.name, @"John");
    
    [p setValue:@"Jay" forKeyPath:@"self.name"];
    XCTAssertEqualObjects(p.name, @"Jay");
}

#pragma mark - Exception

- (void)test_valueForKey_or_valueForKeyPath_exception {
    Person *p = [Person new];
    p.name = @"John";
    
    XCTAssertThrows([p valueForKey:@"name2"]);
    XCTAssertThrows([p valueForKeyPath:@"self.name2"]);
}

- (void)test_setValue_forKey_or_setValue_forKeyPath_exception {
    Person *p = [Person new];
    
    XCTAssertThrows([p setValue:@"John" forKey:@"name2"]);
    XCTAssertThrows([p setValue:@"Jay" forKeyPath:@"self.name2"]);
}

@end
