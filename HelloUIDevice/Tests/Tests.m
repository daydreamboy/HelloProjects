//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/10/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDeviceTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)test_deviceProcessorArchType {
    NSString *output = [WCDeviceTool deviceProcessorArchType];
    NSLog(@"%@", output);
}

@end
