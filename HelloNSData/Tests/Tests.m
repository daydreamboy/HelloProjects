//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/9/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDataTool.h"

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

- (void)test_MIMETypeInfoWithData {
    NSData *data;
    NSString *filePath;
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"1" ofType:@"amr"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAmr);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"3" ofType:@"avi"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAvi);
}

- (void)test_float {
    long double f = 28.0 / (488.0 / 12.0);
    NSLog(@"%Lf", f);
}

@end