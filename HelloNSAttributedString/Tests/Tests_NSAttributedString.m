//
//  Tests_NSAttributedString.m
//  Tests
//
//  Created by wesley_chen on 2018/10/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSAttributedString : XCTestCase

@end

@implementation Tests_NSAttributedString

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_attributedSubstringFromRange {
    NSAttributedString *string;
    NSAttributedString *substring;
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [string attributedSubstringFromRange:NSMakeRange(0, 0)];
    XCTAssertTrue([substring isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]);
    
    // Case
    string = nil;
    substring = [string attributedSubstringFromRange:NSMakeRange(0, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    XCTAssertThrows([string attributedSubstringFromRange:NSMakeRange(1, 0)]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [string attributedSubstringFromRange:NSMakeRange(2, 0)];
    XCTAssertTrue([substring isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [string attributedSubstringFromRange:NSMakeRange(3, 0)];
    XCTAssertTrue([substring isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@""]]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    XCTAssertThrows([string attributedSubstringFromRange:NSMakeRange(3, 1)]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    XCTAssertThrows([string attributedSubstringFromRange:NSMakeRange(4, 0)]);
}

@end
