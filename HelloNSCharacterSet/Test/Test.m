//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCCharacterSetTool.h"

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

// @see https://gist.github.com/daydreamboy/207fc752ee62dc329ec7a5577f5f4122
- (void)test_WCCharacterSetTool_charactersInCharacterSet {
    NSArray *array;
    NSString *string;
    
    // Case 1
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
    
    // Case 2
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
    
    // Case 3
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
    
    // Case 4
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
    
    // Case 5
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
    
    // Case 6
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
}

- (void)test_check_letterCharacterSet {
    NSArray *array;
    NSString *string;
    
    // Case 1
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet letterCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
}

- (void)test_check_decimalDigitCharacterSet {
    NSArray *array;
    NSString *string;
    
    // Case 1
    array = [WCCharacterSetTool charactersInCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    string = [array componentsJoinedByString:@""];
    NSLog(@"%@", string);
}

@end
