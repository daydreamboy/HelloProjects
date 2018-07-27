//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test_NSDataDetector : XCTestCase

@end

@implementation Test_NSDataDetector

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_check_hyperlink {
    NSString *string;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
//    string = @"测试连接www.baidu.com,测试连接http://www.baidu.com测试连接https://www.baidu.com";
    //detector matchesInString:string options:kNilOptions range:<#(NSRange)#>
    
    NSCache *cache = [NSCache new];
    cache.totalCostLimit = 5;
    
    [cache setObject:@"2" forKey:@"2" cost:2];
    [cache setObject:@"3" forKey:@"3" cost:3];
    [cache setObject:@"1" forKey:@"1" cost:1];
    
    string = [cache objectForKey:@"3"];
    NSLog(@"%@", string);
    XCTAssertNil(string);
    
    string = [cache objectForKey:@"1"];
    NSLog(@"%@", string);
    XCTAssertNil(string);
    
    string = [cache objectForKey:@"2"];
    NSLog(@"%@", string);
    XCTAssertNil(string);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
