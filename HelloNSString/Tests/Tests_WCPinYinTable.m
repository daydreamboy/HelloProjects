//
//  Tests_WCPinYinTable.m
//  Tests
//
//  Created by wesley_chen on 2020/8/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCPinYinTable.h"

@interface Tests_WCPinYinTable : XCTestCase

@end

@implementation Tests_WCPinYinTable

- (void)setUp {
    NSLog(@"\n");
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

@end
