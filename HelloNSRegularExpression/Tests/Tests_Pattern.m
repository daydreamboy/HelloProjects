//
//  Tests_Pattern.m
//  Tests
//
//  Created by wesley_chen on 2021/1/29.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_Pattern : XCTestCase

@end

@implementation Tests_Pattern

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_strip_HTML_tag {
    // @see https://stackoverflow.com/questions/9661690/use-regular-expression-to-find-replace-substring-in-nsstring
    NSString *string;
    NSString *pattern;
    NSRegularExpression *regex;
    NSError *error = nil;
    
    pattern = @"</?.*?>";
    
    // Case 1
    // <red>至</red>尊宝 => 至尊宝
    string = @"<red>至</red>尊宝";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    XCTAssertEqualObjects(string, @"至尊宝");
    
    // Case 2
    string = @"<red>>至</red>尊宝";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    XCTAssertEqualObjects(string, @">至尊宝");
    
    pattern = @"</?.*>";
    
    // Case 1
    string = @"<red>>至</red>尊宝";
    regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    XCTAssertEqualObjects(string, @"尊宝");
}

@end
