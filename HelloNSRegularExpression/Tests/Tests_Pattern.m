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
    NSString *pattern = @"</?.*?>";
    
    // <red>至</red>尊宝 => 至尊宝
    string = @"<red>至</red>尊宝";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    string = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    
    XCTAssertEqualObjects(string, @"至尊宝");
}

@end
