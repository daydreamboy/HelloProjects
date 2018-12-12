//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 20/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCRegularExpressionTool.h"

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
    // Note: `￥` and `¥` is different
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
    NSMutableArray *captureRanges = [NSMutableArray array];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [regex enumerateMatchesInString:matchString options:kNilOptions range:NSMakeRange(0, matchString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        
        NSRange matchRange = result.range;
        if (matchRange.location == NSNotFound) return;
        
        NSLog(@"matchRange: %@ - %@", NSStringFromRange(matchRange), [matchString substringWithRange:matchRange]);
        
        for (NSInteger index = 1; index < result.numberOfRanges; index++) {
            NSRange captureRange = [result rangeAtIndex:index];
            if (captureRange.location != NSNotFound) {
                NSLog(@"captureRange: %@ - %@", NSStringFromRange(captureRange), [matchString substringWithRange:captureRange]);
                
                [captureRanges addObject:[NSValue valueWithRange:captureRange]];
            }
        }
    }];
    
    NSLog(@"--------------------------------");
    
    return captureRanges;
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

- (void)test_url {
    NSString *pattern;
    NSString *matchString;
    
    pattern = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    // Case 1
    matchString = @"http://www.example.com";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    // Case 2
    matchString = @"http://www.example.es";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    // Case 3
    matchString = @"https://www.example.com/index?param=a";
    [self runRegexWithPattern:pattern matchString:matchString];

    // Case 4: not valid
    matchString = @"www.example.com";
    [self runRegexWithPattern:pattern matchString:matchString];

    // Case 5: not valid
    matchString = @"example.com";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    // Case 6: not valid
    matchString = @"example";
    [self runRegexWithPattern:pattern matchString:matchString];

    // Case 7: not valid
    matchString = @"http://example";
    [self runRegexWithPattern:pattern matchString:matchString];

    // Case 8
    matchString = @"http://example.com";
    [self runRegexWithPattern:pattern matchString:matchString];

    // Case 9: not valid
    matchString = @"www.example";
    [self runRegexWithPattern:pattern matchString:matchString];
    
    // Case 10
    matchString = @"https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
    [self runRegexWithPattern:pattern matchString:matchString];
}

- (void)test_emoticon_code {
    NSString *emoticonCodePlistPath = [[NSBundle mainBundle] pathForResource:@"EmoticonInfo" ofType:@"plist"];
    
    // code (/:^_^) -> png name
    NSMutableDictionary<NSString *, NSString *> *dictM = [NSMutableDictionary dictionary];
    
    NSDictionary<NSString *, NSArray *> *emotionCodeDict = [NSDictionary dictionaryWithContentsOfFile:emoticonCodePlistPath];
    [emotionCodeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]] && obj.count == 2) {
            NSArray *arr = (NSArray *)obj;
            dictM[arr[1]] = [NSString stringWithFormat:@"%@@2x.png", key];
        }
    }];
    
    NSString *patternOfEmoticon = @"(\\/\\:[a-zA-Z0-9_^$<>'~!%&=\\-\\.\\*\\?\\@\\(\\)\\\"]+)";
    NSInteger numberOfValidItems = 0;
    for (NSString *key in [dictM allKeys]) {
        NSArray *ranges = [self runRegexWithPattern:patternOfEmoticon matchString:key];
        if (ranges.count == 0) {
            NSLog(@"Check here: %@", key);
            break;
        }
        else {
            NSRange range = [[ranges firstObject] rangeValue];
            XCTAssertEqualObjects(key, [key substringWithRange:range]);
        }
        numberOfValidItems++;
    }
    XCTAssertEqual(numberOfValidItems, [dictM allKeys].count);
}

- (void)test_translate_emoticon_display_format_to_emoticon_code {
    NSString *emoticonCodePlistPath = [[NSBundle mainBundle] pathForResource:@"EmoticonInfo" ofType:@"plist"];
    
    // 1. prepare map
    // 天使 -> /:065
    NSMutableDictionary<NSString *, NSString *> *dictM = [NSMutableDictionary dictionary];
    
    NSDictionary<NSString *, NSArray *> *emotionCodeDict = [NSDictionary dictionaryWithContentsOfFile:emoticonCodePlistPath];
    [emotionCodeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]] && obj.count == 2) {
            NSArray *arr = (NSArray *)obj;
            dictM[[NSString stringWithFormat:@"%@", arr[0]]] = arr[1];
        }
    }];
    
    
    // 2. check by pattern
    NSString *pattern = @"\\[(.+?)\\]";
    NSString *string;
    string = @"测试表情[微笑]另一个表情[害羞]...";
    
    NSMutableArray<NSString *> *matchStrings = [NSMutableArray array];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 2) {
            NSRange captureRange = [result rangeAtIndex:1];
            if (captureRange.location != NSNotFound) {
                NSString *substring = [string substringWithRange:captureRange];
                if (substring.length) {
                    NSString *code = dictM[substring];
                    if (code.length) {
                        [matchStrings addObject:substring];
                    }
                }
            }
        }
    }];
    
    // 3. replace display format to code
    NSMutableString *stringM = [string mutableCopy];
    for (NSString *match in matchStrings) {
        NSString *code = dictM[match];
        NSString *stringToReplace = [NSString stringWithFormat:@"[%@]", match];
        [stringM replaceOccurrencesOfString:stringToReplace withString:code options:kNilOptions range:NSMakeRange(0, stringM.length)];
    }
    
    NSLog(@"%@", stringM);
}

- (void)test_non_greedy_capture {
    
    NSString *pattern = @"\\[([^\\]]*)\\]"; // not match @"[]]"
    // Note: `+?` Match 1 or more times. Match as few times as possible.
    // `*?` Match 0 or more times. Match as few times as possible.
    pattern = @"\\[(.+?)\\]";
    
    // Case 1
    NSString *string;
    string = @"测试表情[微笑]另一个表情[害羞]";
//    string = @"[]";
//    string = @"[]]测试[a]";
//    string = @"[[]";
//    string = @"[[]]";
    
    NSMutableArray<NSString *> *matchStrings = [NSMutableArray array];
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 2) {
            NSRange captureRange = [result rangeAtIndex:1];
            if (captureRange.location != NSNotFound) {
                NSString *substring = [string substringWithRange:captureRange];
                if (substring.length) {
                    [matchStrings addObject:substring];
                }
            }
        }
    }];
    
    for (NSString *match in matchStrings) {
        NSLog(@"%@", match);
    }
}

#pragma mark -

- (void)test_enumerateMatchesInString_pattern_usingBlock {
    NSString *string;
    NSMutableArray<NSString *> *output;
    
    // Case 1
    output = [NSMutableArray array];
    string = @"$a$b,${a},$!{b}c";
    BOOL status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:@"\\$!?(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))" usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
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
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 4);
    XCTAssertEqualObjects(output[0], @"a");
    XCTAssertEqualObjects(output[1], @"b");
    XCTAssertEqualObjects(output[2], @"a");
    XCTAssertEqualObjects(output[3], @"b");
}

- (void)test_stringByReplacingMatchesInString_pattern_captureGroupBindingBlock {
    NSString *pattern;
    NSString *string;
    NSString *output;
    NSDictionary *bindings;
    
    // Case 1
    pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))";
    bindings = @{
                 @"a": @"A",
                 @"b": @"B"
                 };
    string = @"$a$b,${a},$!{b}c";
    output = [WCRegularExpressionTool stringByReplacingMatchesInString:string pattern:pattern captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        for (NSString *captureGroupString in captureGroupStrings) {
            if (bindings[captureGroupString]) {
                NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                return bindings[captureGroupString];
            }
        }
        
        return nil;
    }];
    XCTAssertEqualObjects(output, @"AB,A,Bc");
    
    // Case 2
    bindings = @{
                 @"a": @"A",
                 @"b": @"B"
                 };
    string = @"a$a$b,${a},$!{b}c";
    output = [WCRegularExpressionTool stringByReplacingMatchesInString:string pattern:pattern captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        for (NSString *captureGroupString in captureGroupStrings) {
            if (bindings[captureGroupString]) {
                NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                return bindings[captureGroupString];
            }
        }
        
        return nil;
    }];
    XCTAssertEqualObjects(output, @"aAB,A,Bc");
    
    // Case 3
    bindings = @{
                 @"a": @"A",
                 @"a-a": @"A",
                 @"b": @"B"
                 };
    string = @"a$a-a$b,${a},$!{b}c";
    output = [WCRegularExpressionTool stringByReplacingMatchesInString:string pattern:pattern captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        for (NSString *captureGroupString in captureGroupStrings) {
            if (bindings[captureGroupString]) {
                NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                return bindings[captureGroupString];
            }
        }
        
        return nil;
    }];
    XCTAssertEqualObjects(output, @"aAB,A,Bc");
    
    // Case 3
    pattern = @"\\$!?(?:\\{([a-zA-Z0-9_\\-\\.\\[\\]\\$]+)\\}|([a-zA-Z0-9_-]+))";
    bindings = @{
                 @"a": @"A",
                 @"b": @"B"
                 };
    string = @"${foo[$i]}";
    output = [WCRegularExpressionTool stringByReplacingMatchesInString:string pattern:pattern captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        NSString *captureGroupString;
        
        if (captureGroupStrings.count == 2) {
            
            if ([captureGroupStrings[0] length]) {
                // match ${a}
                
                captureGroupString = captureGroupStrings[0];
                if (bindings[captureGroupString]) {
                    NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                    return bindings[captureGroupString];
                }
            }
            else if ([captureGroupStrings[1] length]) {
                // match $a
                
                captureGroupString = captureGroupStrings[0];
                if (bindings[captureGroupString]) {
                    NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                    return bindings[captureGroupString];
                }
            }
        }
        
        return nil;
    }];
    XCTAssertEqualObjects(output, @"aAB,A,Bc");
}

- (void)test_checkPatternWithString_error {
    NSString *pattern;
    NSString *string;
    NSString *output;
    BOOL valid;
    
    // Case 1
    pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-.]+)\\}|([a-zA-Z0-9_-]+))";
    valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
    XCTAssertFalse(valid);
    
    // Case 2:
    pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-\\.]+)\\}|([a-zA-Z0-9_-]+))";
    valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
    XCTAssertFalse(valid);
    
    // Case 3
    pattern = @"\\$!?(?:\\{([a-zA-Z0-9_\\-\\.]+)\\}|([a-zA-Z0-9_-]+))";
    valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
    XCTAssertTrue(valid);
    
    // Case 4
    pattern = @"a-z";
    valid = [WCRegularExpressionTool checkPatternWithString:pattern error:nil];
    XCTAssertTrue(valid);
    
    string = @"a-z";
    pattern = @"a-z";
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern];
    XCTAssertEqualObjects(output, @"a-z");
    
    string = @"b";
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern];
    XCTAssertNil(output);
    
    string = @"B";
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern];
    XCTAssertNil(output);
}

@end
