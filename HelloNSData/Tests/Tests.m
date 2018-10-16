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
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"amr" ofType:@"amr"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAmr);

    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"avi" ofType:@"avi"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAvi);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"mkv" ofType:@"mkv"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeMkv);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"opus" ofType:@"opus"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeOpus);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"webm" ofType:@"webm"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeWebm);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"xpi" ofType:@"xpi"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeZip && [WCDataTool checkMIMETypeWithData:data type:WCMIMETypeXpi].type == WCMIMETypeXpi);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"heic" ofType:@"heic"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool checkMIMETypeWithData:data type:WCMIMETypeHeif].type == WCMIMETypeHeif);
}

- (void)test_float {
    long double f = 28.0 / (488.0 / 12.0);
    NSLog(@"%Lf", f);
}

@end
