//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 20/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

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

- (void)test_price {
    NSString *pattern;
    NSString *matchString;
    
    // Case 1
    pattern = @"￥(\\d+)(?:\\.\\d+)?(?:-(\\d+)(?:\\.\\d+)?)?";
    
    // ￥1
    // ￥1.5
    // ￥1.5-20
    // ￥1.5-20.5
    
    matchString = @"￥1";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"￥1.5";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"￥1.5-20";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"￥1.5-20.5";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    //
    matchString = @"abc￥2.5-21.5";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"abc￥00.5-02.5";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"abc￥1.5-2.5-03.6";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    // Case 2
    pattern = @"^￥(\\d+)(?:\\.\\d+)?(?:-(\\d+)(?:\\.\\d+)?)?";
    matchString = @"abc￥2.5-21.5";
    [self runRegexWithPattern:pattern matchString:matchString];
}

- (void)runRegexWithPattern:(NSString *)pattern matchString:(NSString *)matchString {
    NSLog(@"--------------------------------");
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [regex enumerateMatchesInString:matchString options:kNilOptions range:NSMakeRange(0, matchString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSRange matchRange = result.range;
        if (matchRange.location == NSNotFound) return;
        
        NSLog(@"matchRange: %@ - %@", NSStringFromRange(matchRange), [matchString substringWithRange:matchRange]);
        
        for (NSInteger index = 1; index < result.numberOfRanges; index++) {
            NSRange captureRange = [result rangeAtIndex:index];
            if (captureRange.location != NSNotFound) {
                NSLog(@"captureRange: %@ - %@", NSStringFromRange(captureRange), [matchString substringWithRange:captureRange]);
            }
        }
    }];
    
    NSLog(@"--------------------------------");
}

- (void)test_domain {
    // @see https://stackoverflow.com/questions/9276246/how-to-write-regular-expressions-in-objective-c-nsregularexpression
    NSString *searchedString = @"domain-name.tld.tld2";
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [searchedString substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
        NSRange group1 = [match rangeAtIndex:1];
        NSRange group2 = [match rangeAtIndex:2];
        NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
        NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
    }
}

- (void)test_floatString {
    NSString *pattern;
    NSString *matchString;
    
    pattern = @"(^-?[0-9]\\d*\\.{0,1}\\d+$)";
    
    matchString = @"1.2";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"-1.2";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"-0.2";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"0.2";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"0.2000";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"0";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"-0";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"-1";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"-01";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    matchString = @"01";
    [self runRegexWithPattern:pattern matchString:matchString];
}

- (void)test_CGRectString {
    NSString *pattern;
    NSString *matchString;
    
    pattern = @"^\\{\\{(.+),(.+)\\},\\{(.+),(.+)\\}\\}$";
    matchString = @"{{1,2},{3,4}}";
    [self runRegexWithPattern:pattern matchString:matchString];
}

@end
