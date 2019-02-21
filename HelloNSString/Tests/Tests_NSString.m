//
//  Tests_NSString.m
//  Tests
//
//  Created by wesley_chen on 2018/10/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSString : XCTestCase

@end

@implementation Tests_NSString

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_substringWithRange {
    NSString *string;
    NSString *substring;
    
    // Case
    string = @"";
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = nil;
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = @"";
    XCTAssertThrows([string substringWithRange:NSMakeRange(1, 0)]);
    
    // Case
    string = @"123";
    substring = [string substringWithRange:NSMakeRange(2, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    substring = [string substringWithRange:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    XCTAssertThrows([string substringWithRange:NSMakeRange(3, 1)]);
    
    // Case
    string = @"123";
    XCTAssertThrows([string substringWithRange:NSMakeRange(4, 0)]);
}

- (void)test_rangeOfCharacterFromSet {
    NSString *string;
    NSRange range;
    
    // Case 1
    string = @"abcd";
    range = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"[,]"]];
    XCTAssertTrue(range.location == NSNotFound);
}

- (void)test_componentsSeparatedByString {
    NSString *string;
    NSUInteger count;
    
    // Case 1
    string = @"pow";
    count = [string componentsSeparatedByString:@":"].count;
    XCTAssert(count == 1);
    
    // Case 2
    string = @"pow:";
    count = [string componentsSeparatedByString:@":"].count;
    XCTAssert(count == 2);
}

- (void)test_commonPrefixWithString_options {
    NSString *string1;
    NSString *string2;
    NSString *output;
    
    // Case 1
    string1 = @"http://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"http://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"http://www.google.com/item.htm?id=1");
    
    // Case 2
    string1 = @"abcdhttp://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"http://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"");
    
    // Case 2
    string1 = @"abcdhttp://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"ehttp://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"");
}

@end
