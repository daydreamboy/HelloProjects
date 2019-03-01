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
    [WCRegularExpressionTool setEnableLogging:YES];
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

- (void)test_pattern_1 {
    NSString *pattern;
    NSString *matchString;
    
    // pattern from https://www.objc.io/issues/9-strings/string-parsing/
    pattern = @"(\\w+) = #(\\p{Hex_Digit}{6})";
    
    // Case 1
    matchString = @"backgroundColor = #ff0000\
                    textColor = #0000ff";
    [self runRegexWithPattern:pattern matchString:matchString];
}

#pragma mark - Get NSTextCheckingResult

- (void)test_enumerateMatchesInString_pattern_usingBlock {
    NSString *string;
    NSString *pattern;
    NSMutableArray *output;
    BOOL status;
    
    // Case 1
    output = [NSMutableArray array];
    string = @"$a$b,${a},$!{b}c";
    pattern = @"\\$!?(?:\\{([a-zA-Z]+[a-zA-Z0-9_-]*)\\}|([a-zA-Z]+[a-zA-Z0-9_-]*))";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
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
    
    // Case 2
    output = [NSMutableArray array];
    string = @"index[start,end]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*),([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"index");
    XCTAssertEqualObjects(output[1], @"start");
    XCTAssertEqualObjects(output[2], @"end");
    
    // Case 3
    output = [NSMutableArray array];
    string = @"index[start,]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"index");
    XCTAssertEqualObjects(output[1], @"start");
    XCTAssertEqualObjects(output[2], [NSNull null]);
    
    // Case 4
    output = [NSMutableArray array];
    string = @"index[,end]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"index");
    XCTAssertEqualObjects(output[1], [NSNull null]);
    XCTAssertEqualObjects(output[2], @"end");
    
    // Case 5
    output = [NSMutableArray array];
    string = @"index[,]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"index");
    XCTAssertEqualObjects(output[1], [NSNull null]);
    XCTAssertEqualObjects(output[2], [NSNull null]);
    
    // Case 6
    output = [NSMutableArray array];
    string = @"index[1,]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertTrue(status);
    XCTAssertTrue(output.count == 3);
    XCTAssertEqualObjects(output[0], @"index");
    XCTAssertEqualObjects(output[1], @"1");
    XCTAssertEqualObjects(output[2], [NSNull null]);
    
    // Abnormal Case 1
    output = [NSMutableArray array];
    string = @"index[,,]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertFalse(status);
    XCTAssertTrue(output.count == 0);
    
    // Abnormal Case 2
    output = [NSMutableArray array];
    string = @"[a,]";
    pattern = @"([a-zA-Z]+[a-zA-Z0-9_\\-\\.]*)\\[([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?,([a-zA-Z0-9]+[a-zA-Z0-9_\\-\\.]*)?\\]";
    status = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges == 4) {
            NSRange rangeOfMatchString = result.range;
            NSRange rangeOfCaptureString1 = [result rangeAtIndex:1];
            NSRange rangeOfCaptureString2 = [result rangeAtIndex:2];
            NSRange rangeOfCaptureString3 = [result rangeAtIndex:3];
            
            NSString *matchString = rangeOfMatchString.location != NSNotFound ? [string substringWithRange:result.range] : nil;
            NSString *captureString1 = rangeOfCaptureString1.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString1] : nil;
            NSString *captureString2 = rangeOfCaptureString2.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString2] : nil;
            NSString *captureString3 = rangeOfCaptureString3.location != NSNotFound ? [string substringWithRange:rangeOfCaptureString3] : nil;
            
            if (captureString1.length) {
                [output addObject:captureString1];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString2.length) {
                [output addObject:captureString2];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            if (captureString3.length) {
                [output addObject:captureString3];
            }
            else {
                [output addObject:[NSNull null]];
            }
            
            NSLog(@"matchString: %@, captureString1: %@, captureString2: %@, captureString3: %@", matchString, captureString1, captureString2, captureString3);
        }
    }];
    
    XCTAssertFalse(status);
    XCTAssertTrue(output.count == 0);
}

#pragma mark - Replace Matched String

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
}

- (void)test_stringByReplacingMatchesInString_regularExpression_captureGroupBindingBlock {
    
    NSString *string;
    NSString *output;
    NSDictionary *bindings;
    NSString *pattern = @"\\$!?(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))";
    WCRegularExpressionTool *tool = [[WCRegularExpressionTool alloc] initWithPattern:pattern options:kNilOptions];
    tool.enableCache = NO;
    
    // Case 1
    bindings = @{
                 @"a": @"A",
                 @"b": @"B"
                 };
    string = @"$a$b,${a},$!{b}c";
    output = [tool stringByReplacingMatchesInString:string captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
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
    output = [tool stringByReplacingMatchesInString:string captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
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
    output = [tool stringByReplacingMatchesInString:string captureGroupBindingBlock:^NSString * _Nonnull(NSString * _Nonnull matchString, NSArray<NSString *> * _Nonnull captureGroupStrings) {
        
        for (NSString *captureGroupString in captureGroupStrings) {
            if (bindings[captureGroupString]) {
                NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                return bindings[captureGroupString];
            }
        }
        
        return nil;
    }];
    XCTAssertEqualObjects(output, @"aAB,A,Bc");
}

#pragma mark > Specific Substitutions

- (void)test_substituteTemplateStringWithString_bindings {
    NSString *string;
    NSString *output;
    NSDictionary *bindings;
    
    // Case 1: Variable
    bindings = @{
                 @"w1": @"is",
                 @"first-word": @"The",
                 @"a_1": @"ark",
                 @"ing": @"ing",
                 };
    string = @"$first-word d$a_1 $w1 someth${ing}.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    // Case 2: Subscript
    bindings = @{
                 @"i": @"bar",
                 @"foo": @{
                         @"bar": @"da"
                         },
                 @"s": @"some",
                 @"ing": @"ing",
                 };
    string = @"The ${foo[$i]}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    bindings = @{
                 @"foo": @{
                         @"0": @"e",
                         },
                 @"foos": @[
                         @"e"
                         ],
                 };
    string = @"Th$foo[0] dark is som${foos[0]}thing.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    bindings = @{
                 @"foo": @{
                         @"bar": @{
                                 @"0": @"e",
                                 }
                         },
                 @"foos": @[
                         @{
                             @"bar": @{
                                     @"0": @"e",
                                     }
                         }
                         ],
                 };
    string = @"Th$foo[bar][0] dark is som${foos[0][bar][0]}thing.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    // Case 3: Dot Reference
    bindings = @{
                 @"foo": @{
                         @"bar": @{
                                 @"0": @"e",
                                 }
                         },
                 @"foos": @[
                         @{
                             @"bar": @{
                                     @"0": @"e",
                                     }
                             }
                         ],
                 };
    string = @"Th$foo.bar.0 dark is som${foos.0.bar.0}thing.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    // Case 4: Catenate With Reserved Characters
    bindings = @{
                 @"word": @"word",
                 @"hello": @"hello",
                 @"world": @"world",
                 };
    string = @"Hello_${word}-like is not ${hello}_${world}.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"Hello_word-like is not hello_world.");
    
    // Case 5: Silent Notation
    bindings = @{
                 @"I'm not foo": @"far",
                 };
    string = @"The $!{foo[$!i]}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The rk is something.");
    
    bindings = @{
                 @"foo": @[
                         @"da"
                         ],
                 };
    string = @"The ${foo[$!i]}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The ${foo[$!i]}rk is something.");
    
    bindings = @{
                 @"foo": @[
                         @"da"
                         ],
                 @"i": @"0"
                 };
    string = @"The ${foo[$!i]}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    bindings = @{
                 @"foo": @[
                         @"da"
                         ],
                 @"i": @"0"
                 };
    string = @"The ${foo.$!i}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    string = @"Th$!c_1 d$!a-1 $!w1 someth$!{ing}.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"Th d  someth.");
    
    // Special Case
    bindings = @{
                 @"foo": @{
                         @"bar": @"is",
                         @"!bar": @"is",
                         }
                 };
    string = @"The dark ${foo[!bar]} something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark is something.");
    
    bindings = @{
                 @"foo": @{
                         @"bar": @"is",
                         @"!bar": @"is",
                         }
                 };
    string = @"The dark $!foo.$!bar something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark  something.");
    
    bindings = @{
                 @"foo": @{
                         @"bar": @"is",
                         @"!bar": @"is",
                         }
                 };
    string = @"The dark $!foo.$bar something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark  something.");
    
    bindings = @{
                 @"foo": @{
                         @"bar": @"is",
                         @"!bar": @"is",
                         }
                 };
    string = @"The dark $foo.$!bar something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark $foo.$!bar something.");
    
    bindings = @{
                 @"foo": @{
                         @"bar": @"is",
                         @"!bar": @"is",
                         }
                 };
    string = @"The dark $foo.$bar something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark $foo.$bar something.");
    
    // Abnormal Case 1: missing fields
    bindings = @{
                 @"$first": @"The",
                 @"$foo": @"da",
                 };
    string = @"$first ${foo[$i]}rk is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"$first ${foo[$i]}rk is something.");
    
    // Abnormal Case 2: field's type not matches string type
    bindings = @{
                 @"array": @"I'm not an array",
                 @"map": @"I'm not a map",
                 @"key": @10,
                 };
    string = @"The first element `$array[0]` of array is same as the value `$map[key]` of $key in the map";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The first element `$array[0]` of array is same as the value `$map[key]` of $key in the map");
    
    // Abnormal Case 3: not correct variable names
    bindings = @{
                 @"_first": @"The",
                 @"@end": @"something",
                 @"is": @"is",
                 @"isA": @"isA"
                 };
    string = @"$_first dark ${${is}A} $@end.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"$_first dark ${isA} $@end.");
    
    // Abnormal Case 4: silent notation not correct
    bindings = @{
                 @"is": @"is",
                 };
    string = @"$_first dark ${$is} $@end.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"$_first dark ${is} $@end.");
    
    bindings = @{
                 @"!is": @"is",
                 };
    string = @"The dark $!!is something.";
    output = [WCRegularExpressionTool substituteTemplateStringWithString:string bindings:bindings];
    XCTAssertEqualObjects(output, @"The dark $!!is something.");
}

#pragma mark - Validate Pattern

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
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern reusableRegex:nil];
    XCTAssertEqualObjects(output, @"a-z");
    
    string = @"b";
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern reusableRegex:nil];
    XCTAssertNil(output);
    
    string = @"B";
    output = [WCRegularExpressionTool firstMatchedStringInString:string pattern:pattern reusableRegex:nil];
    XCTAssertNil(output);
}

#pragma mark - Greedy vs. Reluctant vs. Possessive

- (void)test_greedy_mode {
    NSString *string;
    NSString *pattern;
    
    string = @"xfooxxxxxxfoo";
    pattern = @".*foo";
    [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
    }];
}

- (void)test_reluctant_mode {
    NSString *string;
    NSString *pattern;
    
    string = @"xfooxxxxxxfoo";
    pattern = @".*?foo";
    [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
    }];
}

- (void)test_possessive_mode {
    NSString *string;
    NSString *pattern;
    BOOL haveOneMatchAtLess;
    
    // Case 1
    string = @"xfooxxxxxxfoo";
    pattern = @".*+foo";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
    }];
    XCTAssertFalse(haveOneMatchAtLess);
    
    // Case 2
    string = @"xfoo";
    pattern = @".*+foo";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
    }];
    XCTAssertFalse(haveOneMatchAtLess);
    
    // Case 3
    string = @"xfoo";
    pattern = @".*+foo";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
    }];
    XCTAssertFalse(haveOneMatchAtLess);
    
    // Case 4
    string = @"\"abc\"";
    pattern = @"\\\"[^\"]*+\\\"";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
        XCTAssertEqualObjects(matchString, @"\"abc\"");
    }];
    XCTAssertTrue(haveOneMatchAtLess);
    
    // Case 5
    string = @"\"abc\"";
    pattern = @"\\\"[^\"]*\\\"";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
        XCTAssertEqualObjects(matchString, @"\"abc\"");
    }];
    XCTAssertTrue(haveOneMatchAtLess);
    
    // Case 6
    string = @"\"abc\"x";
    pattern = @"\\\".*+\\\"";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
        XCTAssertEqualObjects(matchString, @"\"abc\"");
    }];
    XCTAssertFalse(haveOneMatchAtLess);
    
    // Case 7
    string = @"\"abc\"x";
    pattern = @"\\\".*\\\"";
    haveOneMatchAtLess = [WCRegularExpressionTool enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *matchString = [string substringWithRange:result.range];
        
        NSLog(@"matchString: %@", matchString);
        XCTAssertEqualObjects(matchString, @"\"abc\"");
    }];
    XCTAssertTrue(haveOneMatchAtLess);
}

@end
