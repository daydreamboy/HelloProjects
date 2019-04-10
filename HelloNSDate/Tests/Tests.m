//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/4/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDateTool.h"

#define WCDumpObject(o) fprintf(stderr, "%s:%d: `%s`= `%s`\n", ((strrchr(__FILE__, '/') ? : __FILE__ - 1) + 1), (int)__LINE__, #o, ([o debugDescription].UTF8String))

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

#pragma mark - Get Date String

- (void)test_stringFromCurrentDateWithFormat {
    // @see http://stackoverflow.com/questions/25616141/time-format-ios-2014-04-28t010321-827753
    // @see http://stackoverflow.com/a/13942921/4794665
    NSDate *date;
    NSString *output1;
    NSString *output2;
    NSString *formatString;
    
    // Case 1
    date = [NSDate date];
    output1 = [NSString stringWithFormat:@"%@", date];
    output2 = [WCDateTool stringFromCurrentDateWithFormat:nil];
    XCTAssertNotEqualObjects(output1, output2);
    WCDumpObject(output1);
    WCDumpObject(output2);
    
    // Case 2: timestamp for logging
    output1 = [WCDateTool stringFromCurrentDateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'ZZ"];
    output2 = [WCDateTool stringFromCurrentDateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'ZZZZZ"];
    WCDumpObject(output1);
    WCDumpObject(output2);
    
    // Case 3:
    //  timestamp for file name (Use '_' instead of ':', because system not allow ':' in file name.
    //  And '/' is not proper for file name, it's also a separator for path)
    output1 = [WCDateTool stringFromCurrentDateWithFormat:@"yyyy-MM-dd'T'HH_mm_ss.SSS'Z'ZZ"];
    WCDumpObject(output1);
    
    // Case 4
    //  timestamp conversion between NSString and NSDate
    
    //  NSDate -> NSString
    formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'ZZ";
    output1 = [WCDateTool stringFromCurrentDateWithFormat:formatString];
    
    // NSString -> NSDate
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = formatString;
    date = [dateFomatter dateFromString:output1];
    output2 = [NSString stringWithFormat:@"%@", date];
    XCTAssertNotEqualObjects(output1, output2);
}

- (void)test_stringFromDate_format {
    NSDate *date;
    NSString *output1;
    NSString *output2;
    NSString *formatString;
    
    // Case 1
    date = [NSDate date];
    output1 = [NSString stringWithFormat:@"%@", date];
    output2 = [WCDateTool stringFromDate:date format:nil];
    XCTAssertNotEqualObjects(output1, output2);
    WCDumpObject(output1);
    WCDumpObject(output2);
    
    // Case 2
    //  NSDate -> NSString
    formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'ZZ";
    output1 = [WCDateTool stringFromDate:date format:formatString];
    
    // NSString -> NSDate
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = formatString;
    date = [dateFomatter dateFromString:output1];
    output2 = [NSString stringWithFormat:@"%@", date];
    XCTAssertNotEqualObjects(output1, output2);
}

@end
