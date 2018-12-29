//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/12/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCColorTool.h"

@interface Tests : XCTestCase
@property (nonatomic, strong) NSScanner *scanner;
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

// Demo for Regular Expression
- (void)test_scanKeyValuePairsWithString {
    NSString *string;
    NSDictionary *output;
    
    // Case 1
    string = @"backgroundColor = #ff0000\
               textColor = #0000ff";
    output = [self scanKeyValuePairsWithString:string];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], @"ff0000");
    XCTAssertEqualObjects(output[@"textColor"], @"0000ff");

    // Case 2
    string = @"backgroundColor = #ff0000textColor = #0000ff";
    output = [self scanKeyValuePairsWithString:string];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], @"ff0000");
    XCTAssertEqualObjects(output[@"textColor"], @"0000ff");
    
    // Abnormal Case 1
    // Error: `2` is unexpected character and make scanner can't scan it
    string = @"backgroundColor = #ff0000backgroundColor2 = #0000ff";
    output = [self scanKeyValuePairsWithString:string];
    NSLog(@"This result never output: %@", output);
}

// Demo for Regular Expression
- (void)test_scanKeyValuePairsWithString_error {
    NSString *string;
    NSDictionary *output;
    NSError *error;
    
    // Abnormal Case 1
    // Error: `2` is unexpected character and make scanner can't scan it
    string = @"backgroundColor = #ff0000backgroundColor2 = #0000ff";
    output = [self scanKeyValuePairsWithString:string error:&error];
    XCTAssertNil(output);
}

// Demo for Parser
- (void)test_parse_error {
    NSString *string;
    NSDictionary *output;
    NSError *error;
    
    // Case 1
    string = @"backgroundColor = #ff0000\
    textColor = #0000ff";
    output = [self parse:string error:&error];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], [UIColor redColor]);
    XCTAssertEqualObjects(output[@"textColor"], [UIColor blueColor]);
    
    // Case 2
    string = @"backgroundColor = #ff0000textColor = #0000ff";
    output = [self parse:string error:&error];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], [UIColor redColor]);
    XCTAssertEqualObjects(output[@"textColor"], [UIColor blueColor]);
    
    // Case 3
    string = @"backgroundColor = (255,0,0)\
    textColor = (0,0,255)";
    output = [self parse:string error:&error];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], [UIColor redColor]);
    XCTAssertEqualObjects(output[@"textColor"], [UIColor blueColor]);
    
    // Case 4
    string = @"backgroundColor = (255,0,0)textColor = (0,0,255)";
    output = [self parse:string error:&error];
    XCTAssert([output isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(output[@"backgroundColor"], [UIColor redColor]);
    XCTAssertEqualObjects(output[@"textColor"], [UIColor blueColor]);
    
    // Abnormal Case 1
    // Error: `2` is unexpected character and make scanner can't scan it
    string = @"backgroundColor = #ff0000backgroundColor2 = #0000ff";
    output = [self parse:string error:&error];
    XCTAssertNil(output);
}

// Demo for tokenization
- (void)test_tokenize {
    NSString *string;
    NSArray *output;
    NSArray *expected;
    
    string = @"myConstant = 100\n"
            @"\nmyView.left = otherView.right * 2 + 10\n"
            @"viewController.view.centerX + myConstant <= self.view.centerX";
    
    output = [self tokenize:string];
    expected = @[@"myConstant", @"=", @100, @"myView", @".", @"left",
                 @"=", @"otherView", @".", @"right", @"*", @2, @"+",
                 @10, @"viewController", @".", @"view", @".",
                 @"centerX", @"+", @"myConstant", @"<=", @"self",
                 @".", @"view", @".", @"centerX"];
    XCTAssertEqualObjects(output, expected);
}

#pragma mark - Example Functions

- (NSDictionary *)scanKeyValuePairsWithString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    
    NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    while (!scanner.isAtEnd) {
        NSString *key = nil;
        NSString *value = nil;
        
        BOOL didScan = [scanner scanCharactersFromSet:letters intoString:&key] &&
                        [scanner scanString:@"=" intoString:NULL] &&
                        [scanner scanString:@"#" intoString:NULL] &&
                        [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&value] &&
                        value.length == 6;
        
        if (didScan) {
            result[key] = value;
        }
        
        [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
    }
    
    return result;
}

- (NSDictionary *)scanKeyValuePairsWithString:(NSString *)string error:(NSError **)error {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    
    NSCharacterSet *hexadecimalCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    while (!scanner.isAtEnd) {
        NSString *key = nil;
        NSString *value = nil;
        
        BOOL didScan = [scanner scanCharactersFromSet:letters intoString:&key] &&
                        [scanner scanString:@"=" intoString:NULL] &&
                        [scanner scanString:@"#" intoString:NULL] &&
                        [scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&value] &&
                        value.length == 6;
        
        if (!didScan) {
            NSString *message = [NSString stringWithFormat:@"Couldn't parse: %lu", (unsigned long)scanner.scanLocation];
            NSDictionary *errorDetail = @{NSLocalizedDescriptionKey: message};
            if (error) {
                *error = [NSError errorWithDomain:@"Scan Domain" code:-1 userInfo:errorDetail];
            }
            return nil;
        }
        else {
            result[key] = value;
        }
        
        [scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
    }
    
    return result;
}

- (NSDictionary *)parse:(NSString *)string error:(NSError **)error {
    self.scanner = [NSScanner scannerWithString:string];
    self.scanner.charactersToBeSkipped = [NSCharacterSet whitespaceCharacterSet];
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSCharacterSet *letters = [NSCharacterSet letterCharacterSet];
    
    while (!self.scanner.isAtEnd) {
        NSString *key = nil;
        UIColor *value = nil;
        
        BOOL didScan = [self.scanner scanCharactersFromSet:letters intoString:&key] &&
        [self.scanner scanString:@"=" intoString:NULL] &&
        [self scanColor:&value];
        
        if (didScan) {
            result[key] = value;
        }
        else {
            return nil;
        }
        
        [self.scanner scanCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:NULL];
    }
    
    return result;
}

- (BOOL)scanColor:(UIColor **)outColor {
    return [self scanHexColorIntoColor:outColor] || [self scanTupleColorIntoColor:outColor];
}

- (BOOL)scanHexColorIntoColor:(UIColor **)outColor {
    NSCharacterSet *hexadecimalCharacterSet =
    [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"];
    NSString *colorString = NULL;
    
    if ([self.scanner scanString:@"#" intoString:NULL] &&
        [self.scanner scanCharactersFromSet:hexadecimalCharacterSet intoString:&colorString] &&
        colorString.length == 6) {
        if (outColor) {
            *outColor = [WCColorTool colorWithHexString:colorString prefix:nil];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)scanTupleColorIntoColor:(UIColor **)outColor {
    NSInteger red = 0, green = 0, blue = 0;
    BOOL didScan = [self.scanner scanString:@"(" intoString:NULL] &&
    [self.scanner scanInteger:&red] &&
    [self.scanner scanString:@"," intoString:NULL] &&
    [self.scanner scanInteger:&green] &&
    [self.scanner scanString:@"," intoString:NULL] &&
    [self.scanner scanInteger:&blue] &&
    [self.scanner scanString:@")" intoString:NULL];
    
    if (didScan) {
        if (outColor) {
            *outColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:1];
        }
        return YES;
    }
    else {
        return NO;
    }
}

- (NSArray<NSString *> *)tokenizeWithString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSMutableArray *tokens = [NSMutableArray array];
    NSArray *operators = @[ @"=", @"+", @"*", @">=", @"<=", @".", @"(", @")", @"," ];
    
    while (![scanner isAtEnd]) {
        for (NSString *operator in operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            [tokens addObject:result];
        }
        
        if ([scanner scanString:@"'" intoString:NULL]) {
            NSString *outString;
            NSCharacterSet *charactersToBeSkipped = scanner.charactersToBeSkipped;
            scanner.charactersToBeSkipped = nil;
            [scanner scanUpToString:@"'" intoString:&outString];
            [scanner scanString:@"'" intoString:NULL];
            scanner.charactersToBeSkipped = charactersToBeSkipped;
            
            [tokens addObject:[NSString stringWithFormat:@"'%@'", outString]];
        }
        
        double doubleResult = 0;
        if ([scanner scanDouble:&doubleResult]) {
            [tokens addObject:@(doubleResult)];
        }
        
        NSLog(@"left string: %@", [scanner.string substringFromIndex:scanner.scanLocation]);
    }
    
    return tokens;
}

- (NSArray<NSString *> *)tokenize:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSMutableArray *tokens = [NSMutableArray array];
    NSArray *operators = @[ @"=", @"+", @"*", @">=", @"<=", @"." ];
    
    while (![scanner isAtEnd]) {
        for (NSString *operator in operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            [tokens addObject:result];
        }
        
        double doubleResult = 0;
        if ([scanner scanDouble:&doubleResult]) {
            [tokens addObject:@(doubleResult)];
        }
    }
    
    return tokens;
}

@end
