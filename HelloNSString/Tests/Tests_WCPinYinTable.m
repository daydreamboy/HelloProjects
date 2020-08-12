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
    
    output = [NSString stringWithFormat:@"%C", (unichar)0x7AD3];
    NSLog(@"%@", output);
    
    output = [NSString stringWithFormat:@"%C", (unichar)0x7ACF];
    NSLog(@"%@", output);
    
    output = [NSString stringWithFormat:@"%C", (unichar)0x7ACD];
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
