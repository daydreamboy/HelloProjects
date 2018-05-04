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

- (NSArray<NSValue *> *)runRegexWithPattern:(NSString *)pattern matchString:(NSString *)matchString {
    NSLog(@"--------------------------------");
    NSError *error;
    NSMutableArray *ranges = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [regex enumerateMatchesInString:matchString options:kNilOptions range:NSMakeRange(0, matchString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSRange matchRange = result.range;
        if (matchRange.location == NSNotFound) return;
        
        NSLog(@"matchRange: %@ - %@", NSStringFromRange(matchRange), [matchString substringWithRange:matchRange]);
        
        for (NSInteger index = 1; index < result.numberOfRanges; index++) {
            NSRange captureRange = [result rangeAtIndex:index];
            if (captureRange.location != NSNotFound) {
                NSLog(@"captureRange: %@ - %@", NSStringFromRange(captureRange), [matchString substringWithRange:captureRange]);
                
                [ranges addObject:[NSValue valueWithRange:captureRange]];
            }
        }
    }];
    
    NSLog(@"--------------------------------");
    
    return ranges;
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

#define STR_OF_JSON(...) @#__VA_ARGS__

- (void)test_velocity_variable {
    NSString *pattern;
    NSString *matchString;
    
    pattern = @"(\\$!?(?:[a-zA-Z]+[a-zA-Z0-9_]*|\\{[a-zA-Z]+[a-zA-Z0-9_]*\\}))";
    matchString = STR_OF_JSON(
    {
        "body": {
            "match1": "¥$amount",
            "match2": "¥$!amount2",
            "match3": "满$!{startFee}.5元使用",
            "match4": "满$!{s1}元使用",
            "match5": "满${s1}元使用",
            "match6": "满$s_s.5元使用",
            "not_match1": "满$!{startFee.5元使用",
            "not_match2": "满$5元使用",
            "not_match3": "满$_5元使用",
        }
    }
    );
    [self runRegexWithPattern:pattern matchString:matchString];
}

// Note: 替换变量采用拆分components然后组合components方式
- (void)test_velocity_variable_interpolation_by_substring_components {
    NSString *pattern;
    NSString *matchString;
    
    NSDictionary *config = @{
                                    @"amount": @"1",
                                    @"amount2": @"2",
                                    @"startFee": @"3",
                                    };
    
    pattern = @"(\\$!?(?:[a-zA-Z]+[a-zA-Z0-9_]*|\\{[a-zA-Z]+[a-zA-Z0-9_]*\\}))";
    matchString = STR_OF_JSON(
                              {
                                  "body": {
                                      "match1": "¥$amount",
                                      "match2": "¥$!amount2",
                                      "match3": "满$!{startFee}.5元使用",
                                      "match4": "满$!{s1}元使用",
                                      "match5": "满${s1}元使用",
                                      "match6": "满$s_s.5元使用",
                                      "match7": "满${startFee}.5元使用",
                                      "not_match1": "满$!{startFee.5元使用",
                                      "not_match2": "满$5元使用",
                                      "not_match3": "满$_5元使用",
                                  }
                              }
                              );
    
    NSMutableArray *substringParts = [NSMutableArray array];
    NSArray *ranges = [self runRegexWithPattern:pattern matchString:matchString];
    
    NSRange previousRange = NSMakeRange(0, 0);
    for (NSInteger i = 0; i < ranges.count; i++) {
        NSValue *value = ranges[i];
        // Note: suppose range is always valid
        NSRange range = [value rangeValue];
        NSRange gap = NSMakeRange(previousRange.location + previousRange.length, range.location - previousRange.location - previousRange.length);
        
        [substringParts addObject:[matchString substringWithRange:gap]];
        
        NSString *originString = [matchString substringWithRange:range];
        NSString *variableName = [originString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$!{}"]];
        BOOL useDefaultEmptyString = [originString hasPrefix:@"$!"];
        NSString *substitueString = config[variableName] ? config[variableName] : (useDefaultEmptyString ? @"" : nil);
        if (substitueString) {
            [substringParts addObject:substitueString];
        }
        else {
            [substringParts addObject:originString];
        }
        if (i == ranges.count - 1) {
            NSRange lastRange = NSMakeRange(range.location + range.length, matchString.length - range.location - range.length);
            NSString *lastPartSubstring = [matchString substringWithRange:lastRange];
            [substringParts addObject:lastPartSubstring];
        }
        
        previousRange = range;
    }
    
    NSString *translatedString = [substringParts componentsJoinedByString:@""];
    
    NSLog(@"%@", substringParts);
    NSLog(@"%@", translatedString);
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[translatedString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"jsonObject: %@", jsonObject);
}

- (void)test_velocity_variable_interpolation_by_traverse_match_first {
    NSString *pattern;
    NSString *matchString;
    
    NSDictionary *config = @{
                             @"amount": @"1",
                             @"amount2": @"2",
                             @"startFee": @"3",
                             };
    
    pattern = @"(\\$!?(?:[a-zA-Z]+[a-zA-Z0-9_]*|\\{[a-zA-Z]+[a-zA-Z0-9_]*\\}))";
    matchString = STR_OF_JSON(
                              {
                                  "body": {
                                      "match1": "¥$amount",
                                      "match2": "¥$!amount2",
                                      "match3": "满$!{startFee}.5元使用",
                                      "match4": "满$!{s1}元使用",
                                      "match5": "满${s1}元使用",
                                      "match6": "满$s_s.5元使用",
                                      "match7": "满${startFee}.5元使用",
                                      "not_match1": "满$!{startFee.5元使用",
                                      "not_match2": "满$5元使用",
                                      "not_match3": "满$_5元使用",
                                  }
                              }
                              );
    
    matchString = STR_OF_JSON(
                              {
                                  "body": {
                                      "not_match2": "满$5元使用",
                                      "not_match3": "满$_5元使用",
                                  }
                              }
                              );
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    
    NSMutableString *translatedString = [matchString mutableCopy];
    
    BOOL matched;
    NSRange range = NSMakeRange(0, translatedString.length);;
    do {
        if (!(range.location < translatedString.length && range.location + range.length <= translatedString.length)) {
            break;
        }
        
        NSTextCheckingResult *result = [regex firstMatchInString:translatedString options:kNilOptions range:range];
        NSRange capturedRange = [result rangeAtIndex:1];
        if (result && (capturedRange.location != NSNotFound && capturedRange.length)) {
            matched = YES;
            
            NSString *originString = [translatedString substringWithRange:capturedRange];
            NSString *variableName = [originString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"$!{}"]];
            BOOL useDefaultEmptyString = [originString hasPrefix:@"$!"];
            NSString *substitueString = config[variableName] ? config[variableName] : (useDefaultEmptyString ? @"" : nil);
            if (substitueString) {
                [translatedString replaceCharactersInRange:capturedRange withString:substitueString];
                range = NSMakeRange(capturedRange.location + substitueString.length, translatedString.length - capturedRange.location - substitueString.length);
            }
            else {
                // Note: config没有替换的值而且不使用$!，则不替换
                range = NSMakeRange(capturedRange.location + capturedRange.length, translatedString.length - capturedRange.location - capturedRange.length);
            }
        }
        else {
            matched = NO;
        }
    } while (matched);
    NSLog(@"%@", translatedString);
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[translatedString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"jsonObject: %@", jsonObject);
}

@end
