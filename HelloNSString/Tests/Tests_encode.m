//
//  Tests_encode.m
//  Tests
//
//  Created by wesley_chen on 2018/9/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_encode : XCTestCase

@end

@implementation Tests_encode

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#define WCDumpBool(var)   NSLog(@"%@:%@: `%s`= %@", @(__FILE_NAME__), @(__LINE__), #var, (var))

- (void)test_encode {
    NSLog(@"%s", @encode(double));
    NSLog(@"%s", @encode(float));
    NSLog(@"%s", @encode(int));
    NSLog(@"%s", @encode(NSInteger));
    NSLog(@"%s", @encode(long));
    NSLog(@"%s", @encode(long long));
    NSLog(@"%s", @encode(BOOL));
}

@end
