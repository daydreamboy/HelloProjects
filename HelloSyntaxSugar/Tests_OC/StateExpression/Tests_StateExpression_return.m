//
//  Tests_StateExpression_return.m
//  Tests_OC
//
//  Created by wesley_chen on 2021/1/28.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_StateExpression_return : XCTestCase

@end

@implementation Tests_StateExpression_return

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_return {
    NSString *text = ({
        NSString *string;
        if (!string) {
            return;
        }
        string;
    });
    
    NSLog(@"never hit this line: %@", text);
}

@end
