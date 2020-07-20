//
//  Tests_lldb_scripts.m
//  Tests
//
//  Created by wesley_chen on 2020/7/20.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_lldb_scripts : XCTestCase

@end

@implementation Tests_lldb_scripts

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_parray {
    const char magicCode[8] = { 0xA1,0xBA,0xBA,0x7A,0x77,0x64,0x64,0xEC };
    printf("%hhX\n", magicCode[0]);
}

@end
