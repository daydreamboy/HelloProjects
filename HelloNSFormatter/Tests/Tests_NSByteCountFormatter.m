//
//  Tests_NSByteCountFormatter.m
//  Tests
//
//  Created by wesley_chen on 2020/6/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSByteCountFormatter : XCTestCase

@end

@implementation Tests_NSByteCountFormatter

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_stringFromByteCount {
    NSUInteger bytes;
    NSString *output;
    
    //
    bytes = 1024 * 1024 * 10;
    output = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleFile];
    NSLog(@"%@", output); // 10.5 MB
    
    output = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleMemory];
    NSLog(@"%@", output); // 10 MB
    
    output = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleDecimal];
    NSLog(@"%@", output); // 10.5 MB
    
    output = [NSByteCountFormatter stringFromByteCount:bytes countStyle:NSByteCountFormatterCountStyleBinary];
    NSLog(@"%@", output); // 10 MB
}

@end
