//
//  Tests_WCPinYinTable.m
//  Tests
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCPinYinTable.h"
#import "WCPinYinTable_Testing.h"

/**
 Start of the asychronous task
 */
#define XCTestExpectation_BEGIN \
NSString *description__ = [NSString stringWithFormat:@"%s:%d", __FUNCTION__, __LINE__]; \
XCTestExpectation *expectation__ = [self expectationWithDescription:description__]; \

/**
 End of the asychronous task

 @param timeout the primitive integer of timeout
 */
#define XCTestExpectation_END(timeout) \
[self waitForExpectationsWithTimeout:(timeout) handler:nil];

/**
 Mark the asychronous task fulfilled/finished
 */
#define XCTestExpectation_FULFILL \
[expectation__ fulfill];

@interface Tests_WCPinYinTable : XCTestCase
@property (nonatomic, copy) NSString *filePath;
@end

@implementation Tests_WCPinYinTable

- (void)setUp {
    NSLog(@"\n");
    
    self.filePath = [[NSBundle mainBundle] pathForResource:@"Unicode2Pinyin" ofType:@"txt"];
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_sharedInstance {
    [self measureBlock:^{
        [WCPinYinTable sharedInstance];
    }];
}

- (void)test_new {
    [self measureBlock:^{
        [NSObject new];
    }];
}

- (void)test_pinYinInfoWithTextCharacter {
    NSString *string = @"中文";
    __block NSMutableString *output;
    
    output = [[NSString stringWithFormat:@"%C", (unichar)0x7AD3] mutableCopy];
    NSLog(@"%@", output);
    
    output = [[NSString stringWithFormat:@"%C", (unichar)0x7ACF] mutableCopy];
    NSLog(@"%@", output);
    
    output = [[NSString stringWithFormat:@"%C", (unichar)0x7ACD] mutableCopy];
    NSLog(@"%@", output);
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        output = [NSMutableString string];
        
        [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            WCPinYinInfo *info = [[WCPinYinTable sharedInstance] pinYinInfoWithTextCharacter:substring];
            if (info) {
                [output appendString:info.pinYinWithTone];
                [output appendString:@" "];
            }
        }];
        
        NSLog(@"%@", output);
        
        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

- (void)test_pinYinStringWithText_type_separator {
    __block NSString *string;
    __block NSString *output;
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        // Case 1
        string = @"我爱你祖国";
        output = [[WCPinYinTable sharedInstance] pinYinStringWithText:string type:WCPinYinStringTypePinYin separator:nil];
        NSLog(@"%@", output);
        XCTAssertEqualObjects(output, @"wo ai ni zu guo");
        
        // Case 2
        string = @"我要学习中文";
        output = [[WCPinYinTable sharedInstance] pinYinStringWithText:string type:WCPinYinStringTypeWithTone separator:nil];
        NSLog(@"%@", output);
        XCTAssertEqualObjects(output, @"wŏ yào xué xí zhōng wén");
        
        // Case 3
        string = @"我要学习英文haha😁";
        output = [[WCPinYinTable sharedInstance] pinYinStringWithText:string type:WCPinYinStringTypeWithTone separator:nil];
        NSLog(@"%@", output);
        XCTAssertEqualObjects(output, @"wŏ yào xué xí yīng wén haha😁");
        
        // Case 3
        string = @"我要学习英文haha😁";
        output = [[WCPinYinTable sharedInstance] pinYinStringWithText:string type:WCPinYinStringTypeFirstLetter separator:nil];
        NSLog(@"%@", output);
        XCTAssertEqualObjects(output, @"w y x x y w haha😁");
        
        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

- (void)test_pinYinMatchPatternsWithText_options {
    __block NSString *string;
    __block NSOrderedSet<NSString *> *output;
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        // Case 1
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionAll];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 21);
        
        // Case 2
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:kNilOptions];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 9);
        
        // Case 3
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionOriginalPinYin];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 9);
        
        // Case 4
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionSinglePinYin];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 3);
        
        // Case 5
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionSimplePinYin];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 3);
        
        // Case 6
        string = @"至尊宝 2020😁";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionFirstLetter];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 9);
        
        // Case 7
        string = @"Hello 至尊宝 2020😁 你好";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionAll];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 30);
        
        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

- (void)test_pinYinMatchPatternsWithText_options_with_polyphone {
    __block NSString *string;
    __block NSOrderedSet<NSString *> *output;
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        // Case 1
        string = @"着重差参";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionAll];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 105);

        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

- (void)test_pinYinMatchPatternsWithText_options_with_abnormal {
    __block NSString *string;
    __block NSOrderedSet<NSString *> *output;
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        // Case 1
        string = @"z";
        output = [[WCPinYinTable sharedInstance] pinYinMatchPatternsWithText:string options:WCPinYinStringPatternOptionAll];
        NSLog(@"%@", output);
        XCTAssertTrue(output.count == 1);

        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

#pragma mark - Testing

- (void)test_createMarkedVowelPinYinWithPinYin_tone {
    NSString *string;
    NSString *output;
    
    string = @"yao";
    output = [WCPinYinTable createMarkedVowelPinYinWithPinYin:string tone:4];
    NSLog(@"%@", output);
    XCTAssertEqualObjects(output, @"yào");
}

@end
