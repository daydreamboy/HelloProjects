//
//  Tests_NSRegularExpression.m
//  Tests
//
//  Created by wesley_chen on 2018/12/10.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSRegularExpression : XCTestCase

@end

@implementation Tests_NSRegularExpression

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_stringByReplacingMatchesInString_options_range_withTemplate {
    NSString *string;
    NSString *output;
    NSRegularExpression *regex;
    NSError *error = nil;
    
    // @see https://stackoverflow.com/a/9661782
    // Case 1
    string = @"123 &1245; Ross&12345; Test 12";
    regex = [NSRegularExpression regularExpressionWithPattern:@"&[^;]*;" options:NSRegularExpressionCaseInsensitive error:&error];
    output = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"<$0>"];
    XCTAssertEqualObjects(output, @"123 <&1245;> Ross<&12345;> Test 12");
    NSLog(@"%@", output);
    
    // Case 2
    string = @"123 &1245; Ross&12345; Test 12";
    regex = [NSRegularExpression regularExpressionWithPattern:@"&[^;]*;" options:NSRegularExpressionCaseInsensitive error:&error];
    output = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    XCTAssertEqualObjects(output, @"123  Ross Test 12");
    NSLog(@"%@", output);
    
    // Case 3
    string = @"123 &1245; Ross&12345; Test 12";
    regex = [NSRegularExpression regularExpressionWithPattern:@"&[^;]*;" options:NSRegularExpressionCaseInsensitive error:&error];
    output = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"$0"];
    XCTAssertEqualObjects(output, @"123 &1245; Ross&12345; Test 12");
    NSLog(@"%@", output);
    
    // Case 4
    // https://stackoverflow.com/a/46899134
    string = @"512512345";
    regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]{3})([0-9]{1,3})([0-9]{0,4})" options:NSRegularExpressionCaseInsensitive error:&error];
    output = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:(string.length > 6 ? @"($1) $2-$3" : @"($1) $2")];
    XCTAssertEqualObjects(output, @"(512) 512-345");
    NSLog(@"%@", output);
    
    string = @"5125";
    regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]{3})([0-9]{1,3})([0-9]{0,4})" options:NSRegularExpressionCaseInsensitive error:&error];
    output = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:(string.length > 6 ? @"($1) $2-$3" : @"($1) $2")];
    XCTAssertEqualObjects(output, @"(512) 5");
    NSLog(@"%@", output);
}

- (void)test_enumerateMatchesInString_options_range_usingBlock {
    NSString *string;
    NSMutableArray<NSString *> *output;
    NSRegularExpression *regex;
    NSError *error = nil;
    
    // Case 1
    output = [NSMutableArray array];
    string = @"$a$b,${a},$!{b}c";
    regex = [NSRegularExpression regularExpressionWithPattern:@"\\$!?(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))" options:NSRegularExpressionCaseInsensitive error:&error];
    //
    [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 3) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            
            NSString *matchString;
            NSString *captureString1;
            NSString *captureString2;
            
            if (rangeOfMatchString.location != NSNotFound) {
                matchString = [string substringWithRange:result.range];
            }
            
            if (rangeOfCaptureString1.location != NSNotFound) {
                captureString1 = [string substringWithRange:rangeOfCaptureString1];
            }
                
            if (rangeOfCaptureString2.location != NSNotFound) {
                captureString2 = [string substringWithRange:rangeOfCaptureString2];
            }
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@", matchString, captureString1, captureString2);
        }
    }];
    XCTAssertTrue(output.count == 4);
    XCTAssertEqualObjects(output[0], @"a");
    XCTAssertEqualObjects(output[1], @"b");
    XCTAssertEqualObjects(output[2], @"a");
    XCTAssertEqualObjects(output[3], @"b");
}

@end
