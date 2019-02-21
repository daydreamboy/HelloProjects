//
//  Tests.m
//  Test
//
//  Created by wesley_chen on 2019/2/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDataDetector.h"

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

- (void)test_check_all_links {
    NSString *string;
    NSString *matchString;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"fakehttps://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"fakehttps://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fake http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 3
    string = @"中文http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 4
    string = @"http://www.google.com/item.htm?id=1中文中文中文";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1中文中文中文");
}

- (void)test_check_http_or_https_links {
    NSString *string;
    NSString *matchString;
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    dataDetector.forceDetectHttpScheme = YES;
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fake http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 3
    string = @"http://www.google.com/item.htm?id=1中文中文中文";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 4
    string = @"http://www.google.com/item.htm?id=1中文中文中文 http://www.google.com/item.htm?id=2中文中文中文";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=2");
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=2");
        }
    }
    
    // Case 4
    string = @"fakehttps://www.google.com/item.htm?id=1 fakehttps://www.google.com/item.htm?id=2 ";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=2");
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=2");
        }
    }
}

- (void)test_check_only_https_links {
    NSString *string;
    NSString *matchString;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    dataDetector.forceDetectHttpScheme = YES;
    dataDetector.allowedLinkSchemes = @[@"https"];
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fakehttp://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
    
    // Case 3
    string = @"http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
    
    // Case 4
    string = @"中文http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
}

- (void)test_check_multiple_links {
    NSString *string;
    NSString *matchString;
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
    string = @"谷歌http://www.google.com/item.htm?id=1 百度http://www.baidu.com/ 搜狗https://www.sougou.com/";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.baidu.com/");
            XCTAssertEqualObjects(matchString, @"http://www.baidu.com/");
        }
        else if (i == 2) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.sougou.com/");
            XCTAssertEqualObjects(matchString, @"https://www.sougou.com/");
        }
    }
}

@end
