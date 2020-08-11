//
//  Tests_WCPinYinTable.m
//  Tests
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCPinYinTable.h"

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

- (void)test_ {
    NSString *string = @"中文";
    __block NSMutableString *output;
    
    output = [NSString stringWithFormat:@"%C", (unichar)0x7AD5];
    
    XCTestExpectation_BEGIN
    
    [[WCPinYinTable sharedInstance] preloadWithFilePath:self.filePath completion:^(BOOL success) {
        
        NSLog(@"load time: %f", [WCPinYinTable sharedInstance].loadTimeInterval);
        
        output = [NSMutableString string];
        
        [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
            WCPinYinInfo *info = [[WCPinYinTable sharedInstance] pinYinInfoWithTextCharacter:substring];
            if (info) {
                [output appendString:info.pinYin];
                [output appendString:@" "];
            }
        }];
        
        NSLog(@"%@", output);
        
        XCTestExpectation_FULFILL
    } async:NO];
    
    XCTestExpectation_END(3)
}

@end
