//
//  Tests_NSDate.m
//  Tests
//
//  Created by wesley_chen on 2019/4/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

#define WCDumpObject(o) fprintf(stderr, "%s:%d: `%s`= `%s`\n", ((strrchr(__FILE__, '/') ? : __FILE__ - 1) + 1), (int)__LINE__, #o, ([o debugDescription].UTF8String))

@interface Tests_NSDate : XCTestCase

@end

@implementation Tests_NSDate

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_descriptionWithLocale {
    // TODO
    NSString *localDate1 = [[NSDate date] descriptionWithLocale:[NSLocale systemLocale]];
    
    NSLog(@"%@", localDate1);
    
    NSString *localDate = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    
    NSLog(@"%@", localDate);
}

- (void)test_stringFromDate {
    // @see https://stackoverflow.com/a/8523294
    NSString *output;
    NSDate *date;
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    date = [formatter dateFromString:@"2019-04-20 12:54:03"];
    
    // Case 1
    formatter.dateFormat = @"dd";
    output = [formatter stringFromDate:date];
    XCTAssertEqualObjects(output, @"20");
    
    // Case 2
    formatter.dateFormat = @"MMM";
    output = [formatter stringFromDate:date];
    XCTAssertEqualObjects(output, @"Apr");
    
    // Case 3
    formatter.dateFormat = @"MM";
    output = [formatter stringFromDate:date];
    XCTAssertEqualObjects(output, @"04");
    
    // Case 4
    formatter.dateFormat = @"yy";
    output = [formatter stringFromDate:date];
    XCTAssertEqualObjects(output, @"19");
}

- (void)test_dateFromString {
    NSString *string;
    NSDate *date;
    NSString *output;
    NSString *dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    
    string = @"2020-07-30T15:19:27+0000";
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = dateFormat;
    date = [formatter dateFromString:string];
    
    // Case 1
    dateFormat = @"MMMd, h:mm a";
    
    // @see https://segmentfault.com/a/1190000012858385
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    formatter.locale = locale;
    formatter.dateFormat = dateFormat;
    output = [formatter stringFromDate:date];
    NSLog(@"%@", output);
}

@end
