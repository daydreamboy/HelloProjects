//
//  Tests_WCAsyncTaskExecutor.m
//  Tests
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCAsyncTaskExecutor.h"

@interface Tests_WCAsyncTaskExecutor : XCTestCase

@end

@implementation Tests_WCAsyncTaskExecutor

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_ {
    WCAsyncTaskExecutor *executor = [WCAsyncTaskExecutor autoreleaseTaskExecutor];
    
    [executor addAsyncTask:^(id  _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
            
    }];
    
    [executor addAsyncTask:^(id  _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
            
    }];
    
    [executor addAsyncTask:^(id  _Nullable data, WCAsyncTaskCompletion  _Nonnull completion) {
            
    }];
}

@end
