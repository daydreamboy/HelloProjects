//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Test : XCTestCase <NSCacheDelegate>

@end

@implementation Test

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_cost_of_NSCache {
    NSString *string;
    NSCache *cache = [NSCache new];
    cache.delegate = self;
    cache.totalCostLimit = 6;
    
    [cache setObject:@"2" forKey:@"2" cost:3];
    [cache setObject:@"3" forKey:@"3" cost:3];
    
    [cache setObject:@"1" forKey:@"1" cost:1];
    
    string = [cache objectForKey:@"3"];
    XCTAssertEqualObjects(string, @"3");
    
    string = [cache objectForKey:@"1"];
    XCTAssertEqualObjects(string, @"1");
    
    string = [cache objectForKey:@"2"];
    XCTAssertNil(string);
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"willEvictObject: %@", obj);
}


@end
