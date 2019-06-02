//
//  Tests_NSNumber.m
//  Tests
//
//  Created by wesley_chen on 2019/1/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSNumber : XCTestCase

@end

@implementation Tests_NSNumber

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_objCType {
    NSNumber *number;
    NSString *type;
    
    // Case 1
    number = @1;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"i");
    
    // Case 2
    number = @YES;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");
    
    // Case 3
    number = @3.14;
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"d");
    
    // Case 4
    number = @('a');
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");
    
    // Case 5
    number = [NSNumber numberWithChar:'b'];
    type = [NSString stringWithUTF8String:[number objCType]];
    XCTAssertEqualObjects(type, @"c");
}

- (void)test_NSNumber {
    // @sa http://nshipster.com/bool/
    __unused NSNumber *n1 = @(YES);
    __unused NSNumber *n2 = @(true);
    __unused NSNumber *n3 = @(1);
    __unused NSNumber *n4 = @(TRUE);
    __unused NSNumber *n5 = (__bridge NSNumber *)kCFBooleanTrue;
    __unused NSNumber *n6 = [@(1)copy];
    
    NSLog(@"\n");
    
    NSNumber *n = [NSNumber numberWithBool:YES];
    const char *type = [n objCType];
    
    n = @(1);
    const char *type2 = [n objCType];
    
    fprintf(stderr, "%s", type);
    printf("%s", type);
    
    if (strcmp([n objCType], @encode(BOOL)) == 0) {
        NSLog(@"this is a bool");
    }
    else if (strcmp([n objCType], @encode(int)) == 0) {
        NSLog(@"this is an int");
    }
    else {
        NSLog(@"Other");
    }
    
    NSNumber *n7 = @(false);
    const char *type3 = [n7 objCType];
    
    const char *s1 = @encode(bool);
    const char *s2 = @encode(BOOL);
}

- (void)test_stringValue {
    NSString *output;
    NSNumber *number;
    
    // Case 1
    number = @(YES);
    output = [number stringValue];
    XCTAssertEqualObjects(output, @"1");
}

@end
