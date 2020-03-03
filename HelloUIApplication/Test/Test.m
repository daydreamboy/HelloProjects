//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2019/8/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCApplicationTool.h"

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
}

- (void)tearDown {
}

- (void)test_JSONObjectWithUserHomeFileName {
    id object;
    
    // Note: place 1.txt at the ~ folder
    object = [WCApplicationTool JSONObjectWithUserHomeFileName:@"1.txt"];
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
    
    // Note: place 1.txt at the ~ folder
    object = [WCApplicationTool JSONObjectWithUserHomeFileName:nil];
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
    
    object = RTCall_JSONObjectWithUserHomeFileName(nil);
    NSLog(@"%@", object);
    XCTAssertNotNil(object);
}

@end
