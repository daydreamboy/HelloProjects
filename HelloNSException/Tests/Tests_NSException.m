//
//  Tests_NSException.m
//  Tests
//
//  Created by wesley_chen on 2018/9/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

static id nilObject = nil;

@interface Tests_NSException : XCTestCase

@end

@implementation Tests_NSException

- (void)test_NSString_APIs {
    /*
     @try {
     NSMutableString *stringM = [[NSMutableString alloc] initWithString:nilObject];
     } @catch (NSException *exception) {
     NSLog(@"%@", exception);
     } @finally {
     NSLog(@"finally");
     }
     */
    
    // assert exception will occur
    XCTAssertThrows([[NSMutableString alloc] initWithString:nilObject]);
    XCTAssertThrows([[NSString alloc] initWithString:nilObject]);
}

#pragma mark - NSException

- (void)test_NSInvalidArgumentException {
    // Note: set objc_exception_throw/__cxa_throw/__cxa_begin_catch as symbol breakpoint
    @try {
        NSMutableArray *arrM = [NSMutableArray array];
        [arrM addObject:nilObject];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        XCTAssertEqualObjects(exception.name, @"NSInvalidArgumentException");
    }
    @finally {
        NSLog(@"finally");
    }
}

- (void)test_NSMallocException {
    // @see https://blog.csdn.net/skylin19840101/article/details/51944701
    @try {
        NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1];
        NSInteger len = 2032935142;
        [data increaseLengthBy:len];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
        XCTAssertEqualObjects(exception.name, @"NSMallocException");
    }
    @finally {
        NSLog(@"finally");
    }
}

@end
