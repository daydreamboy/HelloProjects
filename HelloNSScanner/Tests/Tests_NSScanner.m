//
//  Tests_NSScanner.m
//  Tests
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSScanner : XCTestCase

@end

@implementation Tests_NSScanner

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_scanString_intoString_1 {
    NSScanner *scanner;
    NSString *string;
    NSString *outString;
    BOOL didScan;
    
    // Case 1
    // Note: by default, scanner is not case sentitive
    string = @"ABC";
    scanner = [NSScanner scannerWithString:string];
    outString = nil;
    didScan = [scanner scanString:@"abc" intoString:&outString];
    XCTAssertTrue(didScan);
    XCTAssertEqualObjects(outString, @"ABC");
    
    // Case 2
    string = @"ABC";
    scanner = [NSScanner scannerWithString:string];
    scanner.caseSensitive = YES;
    outString = nil;
    didScan = [scanner scanString:@"abc" intoString:&outString];
    XCTAssertFalse(didScan);
    XCTAssertNil(outString);
}

- (void)test_scanString_intoString_2 {
    NSScanner *scanner;
    NSString *string;
    NSString *outString;
    BOOL didScan;
    
    // Case 1
    string = @"\nABC";
    scanner = [NSScanner scannerWithString:string];
    scanner.caseSensitive = YES;
    outString = nil;
    didScan = [scanner scanString:@"ABC" intoString:&outString];
    XCTAssertTrue(didScan);
    XCTAssertEqualObjects(outString, @"ABC");
    
    // Case 2
    string = @"\n   \nABC";
    scanner = [NSScanner scannerWithString:string];
    scanner.caseSensitive = YES;
    outString = nil;
    didScan = [scanner scanString:@"ABC" intoString:&outString];
    XCTAssertTrue(didScan);
    XCTAssertEqualObjects(outString, @"ABC");
}

- (void)test_scanUpToString_intoString {
    NSScanner *scanner;
    NSString *string;
    NSString *outString;
    
    // Case 1
    string = @" 'a b c' ";
    scanner = [NSScanner scannerWithString:string];
    outString = nil;
    if ([scanner scanString:@"'" intoString:NULL]) {
        [scanner scanUpToString:@"'" intoString:&outString];
    }
    XCTAssertEqualObjects(outString, @"a b c");
    
    // Case 2
    string = @" ' b c' ";
    scanner = [NSScanner scannerWithString:string];
    outString = nil;
    if ([scanner scanString:@"'" intoString:NULL]) {
        [scanner scanUpToString:@"'" intoString:&outString];
    }
    XCTAssertEqualObjects(outString, @"b c");
    
    // Case 3
    string = @" '  ' ";
    scanner = [NSScanner scannerWithString:string];
    outString = nil;
    if ([scanner scanString:@"'" intoString:NULL]) {
        [scanner scanUpToString:@"'" intoString:&outString];
    }
    XCTAssertNil(outString);
    
    // Case 4
    string = @"'pow:'";
    scanner = [NSScanner scannerWithString:string];
    outString = nil;
    if ([scanner scanString:@"'" intoString:NULL]) {
        scanner.charactersToBeSkipped = nil;
        [scanner scanUpToString:@"'" intoString:&outString];
        [scanner scanString:@"'" intoString:NULL];
    }
    XCTAssertEqualObjects(outString, @"pow:");
}

@end
