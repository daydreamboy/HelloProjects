//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    NSString *string;
    
    string = @"\u1F604";
    NSLog(@"%@", string);
}

@end
