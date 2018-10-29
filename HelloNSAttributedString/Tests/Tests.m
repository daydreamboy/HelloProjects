//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/10/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCAttributedStringTool.h"

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

- (void)test_attributedSubstringWithAttributedString_range {
    NSAttributedString *string;
    NSAttributedString *substring;
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"2014-11-07 18:36:04"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(5, 5)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@"11-07"]);
    
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(string.length - 1, 1)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@"4"]);
    
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(string.length - 1, 4)];
    XCTAssertNil(substring);
    
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(string.length, 1)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"abc"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 1)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@"a"]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 1)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"abc"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"abc"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(1, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = nil;
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 1)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = nil;
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(0, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@""];
    substring = ([WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(1, 0)]);
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(2, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(substring, [[NSAttributedString alloc] initWithString:@""]);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(3, 1)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(4, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(3, NSUIntegerMax)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(NSUIntegerMax, 3)];
    XCTAssertNil(substring);
    
    // Case
    string = [[NSAttributedString alloc] initWithString:@"123"];
    substring = [WCAttributedStringTool attributedSubstringWithAttributedString:string range:NSMakeRange(-1, 3)];
    XCTAssertNil(substring);
}

- (void)test_replaceCharactersInRangesWithAttributedString_ranges_replacementAttributedStrings_replacementRanges {
#define PlainAttributedString(str)  ([[NSAttributedString alloc] initWithString:str])
    
    NSAttributedString *inputString;
    NSArray<NSValue *> *ranges;
    NSArray<NSAttributedString *> *replacements;
    NSAttributedString *outputString;
    
    // Case 1
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 1)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               [NSValue valueWithRange:NSMakeRange(2, 1)],
               [NSValue valueWithRange:NSMakeRange(3, 1)],
               [NSValue valueWithRange:NSMakeRange(4, 1)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(6, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 1)],
               [NSValue valueWithRange:NSMakeRange(8, 1)],
               [NSValue valueWithRange:NSMakeRange(9, 1)],
               ];
    replacements = @[
                     PlainAttributedString(@"Aa"),
                     PlainAttributedString(@"Bb"),
                     PlainAttributedString(@"Cc"),
                     PlainAttributedString(@"Dd"),
                     PlainAttributedString(@"Ee"),
                     PlainAttributedString(@"Ff"),
                     PlainAttributedString(@"Gg"),
                     PlainAttributedString(@"Hh"),
                     PlainAttributedString(@"Ii"),
                     PlainAttributedString(@"Jj"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"AaBbCcDdEeFfGgHhIiJj"));
    
    // Case 2
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 3)],
               ];
    replacements = @[
                     PlainAttributedString(@"A"),
                     PlainAttributedString(@"B"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"0A456B"));
    
    // Case 3
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 3)],
               [NSValue valueWithRange:NSMakeRange(7, 2)],
               ];
    replacements = @[
                     PlainAttributedString(@"A"),
                     PlainAttributedString(@"B"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"0A456B9"));
    
    // Case 4
    inputString = PlainAttributedString(@"0中文12345678😆9");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(1, 2)],
               // Note: 😆'length is 2
               [NSValue valueWithRange:NSMakeRange(11, 2)],
               ];
    replacements = @[
                     PlainAttributedString(@"鐘文"),
                     PlainAttributedString(@"😄"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"0鐘文12345678😄9"));
    
    // Case 5
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(9, 1)],
               [NSValue valueWithRange:NSMakeRange(8, 1)],
               [NSValue valueWithRange:NSMakeRange(7, 1)],
               [NSValue valueWithRange:NSMakeRange(6, 1)],
               [NSValue valueWithRange:NSMakeRange(5, 1)],
               [NSValue valueWithRange:NSMakeRange(4, 1)],
               [NSValue valueWithRange:NSMakeRange(3, 1)],
               [NSValue valueWithRange:NSMakeRange(2, 1)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               [NSValue valueWithRange:NSMakeRange(0, 1)],
               ];
    replacements = @[
                     PlainAttributedString(@"Jj"),
                     PlainAttributedString(@"Ii"),
                     PlainAttributedString(@"Hh"),
                     PlainAttributedString(@"Gg"),
                     PlainAttributedString(@"Ff"),
                     PlainAttributedString(@"Ee"),
                     PlainAttributedString(@"Dd"),
                     PlainAttributedString(@"Cc"),
                     PlainAttributedString(@"Bb"),
                     PlainAttributedString(@"Aa"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"AaBbCcDdEeFfGgHhIiJj"));
    
    // Case 5
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[];
    replacements = @[];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertEqualObjects(outputString, PlainAttributedString(@"0123456789"));
    
    // Abnormal Case 1: range out of bounds
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 11)],
               ];
    replacements = @[
                     PlainAttributedString(@"A"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertNil(outputString);
    
    // Abnormal Case 2: ranges has intersection
    inputString = PlainAttributedString(@"0123456789");
    ranges = @[
               [NSValue valueWithRange:NSMakeRange(0, 3)],
               [NSValue valueWithRange:NSMakeRange(1, 1)],
               ];
    replacements = @[
                     PlainAttributedString(@"A"),
                     PlainAttributedString(@"B"),
                     ];
    
    outputString = [WCAttributedStringTool replaceCharactersInRangesWithAttributedString:inputString ranges:ranges replacementAttributedStrings:replacements replacementRanges:nil];
    XCTAssertNil(outputString);
    
#undef PlainAttributedString
}

- (void)testExample {
    // Case 1
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"0123456789"];
    
    NSAttributedString *replacementString = [[NSAttributedString alloc] initWithString:@"T"];
    
    NSArray *ranges = @[
                        [NSValue valueWithRange:NSMakeRange(0, 1)],
                        [NSValue valueWithRange:NSMakeRange(1, 3)],
                        [NSValue valueWithRange:NSMakeRange(8, 1)],
                        ];
    
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:@""];
    NSRange previousRange = NSMakeRange(0, 0);
    for (NSInteger i = 0; i < ranges.count; i++) {
        NSRange range = [ranges[i] rangeValue];
        NSRange rangeOfStringToAppend = NSMakeRange(previousRange.location + previousRange.length, range.location - previousRange.location - previousRange.length);
        
        NSAttributedString *attrStringToAppend = [WCAttributedStringTool attributedSubstringWithAttributedString:attrString range:rangeOfStringToAppend];
        if (attrStringToAppend) {
            [attrStringM appendAttributedString:attrStringToAppend];
            [attrStringM appendAttributedString:replacementString];
        }
        
        if (i == ranges.count - 1 && range.location + range.length < attrString.length) {
            NSRange rangeOfLastStringToAppend = NSMakeRange(range.location + range.length, attrString.length - range.location - range.length);
            NSAttributedString *lastAttrStringToAppend = [WCAttributedStringTool attributedSubstringWithAttributedString:attrString range:rangeOfLastStringToAppend];
            if (lastAttrStringToAppend) {
                [attrStringM appendAttributedString:lastAttrStringToAppend];
            }
        }
        
        previousRange = range;
    }
    
    NSLog(@"%@", attrStringM);
    
    //
}

@end
