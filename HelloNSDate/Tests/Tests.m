//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/4/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDateTool.h"

#define WCDumpObject(o) fprintf(stderr, "%s:%d: `%s`=`%s`\n", ((strrchr(__FILE__, '/') ? : __FILE__ - 1) + 1), (int)__LINE__, #o, ([o debugDescription].UTF8String))

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

#pragma mark - Components of Date (without time zone)

#pragma mark > Get component of date

- (void)test_dateComponentsWithDate {
    NSDate *date;
    WCDateComponents *dateComponents;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    // Case 1
    date = [formatter dateFromString:@"2019-04-20 12:54:03"];
    dateComponents = [WCDateTool dateComponentsWithDate:date];
    
    XCTAssert(dateComponents.year == 2019);
    XCTAssert(dateComponents.month == 4);
    XCTAssert(dateComponents.day == 20);
    
    XCTAssert(dateComponents.nearestHour == 13);
    XCTAssert(dateComponents.hour == 12);
    XCTAssert(dateComponents.minute == 54);
    XCTAssert(dateComponents.second == 3);
    
    XCTAssert(dateComponents.nthWeekday == 3);
    XCTAssert(dateComponents.weekday == WCWeekdaySaturday);
    
    XCTAssert(dateComponents.weekOfMonth == 3);
    XCTAssert(dateComponents.weekOfYear == 16);
}

#pragma mark - Date Component Comparison

- (void)test_sameDateComponentWithDate_anotherDate_dateComponentType {
    NSDate *date1;
    NSDate *date2;
    BOOL isSame;
    
    // Case 1
    date1 = [NSDate date];
    date2 = date1;
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeYear];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeDay];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeHour];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMinute];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeSecond];
    XCTAssertTrue(isSame);

    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekday];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfYear];
    XCTAssertTrue(isSame);
    
    // Case 2
    date1 = [NSDate date];
    sleep(1);
    date2 = [NSDate date];
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeYear];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeDay];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeHour];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMinute];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeSecond];
    XCTAssertFalse(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekday];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfYear];
    XCTAssertTrue(isSame);
}

#pragma mark - Adjust Date

- (void)test_dateWithDate_offset_dateComponentType {
    NSDate *date1;
    NSDate *date2;
    BOOL isSame;
    WCDateComponents *dateComponents;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:@"2019-04-20 12:54:03"];
    
    // Case 1
    date1 = date;
    date2 = [WCDateTool dateWithDate:date1 offset:1 dateComponentType:WCDateComponentTypeWeekOfYear];
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeYear];
    XCTAssertFalse(isSame);
    dateComponents = [WCDateTool dateComponentsWithDate:date2];
    XCTAssertTrue(dateComponents.year = 2020);
    
    // Case 2
    date2 = [WCDateTool dateWithDate:date1 offset:1 dateComponentType:WCDateComponentTypeWeekOfMonth];
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeDay];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeHour];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMinute];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeSecond];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekday];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfYear];
    XCTAssertTrue(isSame);
    
    // Case 2
    date1 = [NSDate date];
    sleep(1);
    date2 = [NSDate date];
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeYear];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeDay];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeHour];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeMinute];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeSecond];
    XCTAssertFalse(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekday];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfMonth];
    XCTAssertTrue(isSame);
    
    isSame = [WCDateTool sameDateComponentWithDate:date1 anotherDate:date2 dateComponentType:WCDateComponentTypeWeekOfYear];
    XCTAssertTrue(isSame);
}

@end
