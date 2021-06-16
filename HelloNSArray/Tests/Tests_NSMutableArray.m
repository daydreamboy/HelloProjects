//
//  Tests_NSMutableArray.m
//  Tests
//
//  Created by wesley_chen on 2021/6/16.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSMutableArray : XCTestCase
@property (nonatomic, copy) NSMutableArray *maybeNotAMutableArray;
@end

@implementation Tests_NSMutableArray

- (void)test_issue_copy_property {
    // WARNING: _maybeNotAMutableArray become immutable after setter (copy)
    self.maybeNotAMutableArray = [NSMutableArray array];
    
    XCTAssertThrowsSpecificNamed([self.maybeNotAMutableArray addObject:@""], NSException, @"NSInvalidArgumentException");
}

@end
