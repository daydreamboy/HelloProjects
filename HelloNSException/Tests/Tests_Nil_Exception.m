//
//  Tests_Nil_Exception.m
//  Tests
//
//  Created by wesley_chen on 2018/9/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

static id nilObject = nil;

@interface Tests_Nil_Exception : XCTestCase

@end

@implementation Tests_Nil_Exception

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_NSString_APIs {
    /*
     @try {
     NSMutableString *stringM = [[NSMutableString alloc] initWithString:nilObject];
     } @catch (NSException *exception) {
     NSLog(@"%@", exception);
     } @finally {
     NSLog(@"finally");
     }
     */
    
    // assert exception will occur
    XCTAssertThrows([[NSMutableString alloc] initWithString:nilObject]);
    XCTAssertThrows([[NSString alloc] initWithString:nilObject]);
}

@end
