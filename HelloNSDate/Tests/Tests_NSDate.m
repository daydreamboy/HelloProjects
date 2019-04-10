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

@end
