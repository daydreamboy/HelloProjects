//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/12/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_get_primitive_return_value {
    SEL selector;
    
    // Case 1
    NSUInteger returnInteger = 0;
    selector = @selector(returnInteger);
    if ([self respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        invocation.target = self;
        invocation.selector = selector;
        
        [invocation invoke];
        [invocation getReturnValue:&returnInteger];
        
        XCTAssertTrue(returnInteger == 10);
    }
    
    // Case 2
    CGRect returnCGRect = CGRectZero;
    selector = @selector(returnCGRect);
    if ([self respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        invocation.target = [UIScreen mainScreen];
        invocation.selector = selector;
        
        [invocation invoke];
        [invocation getReturnValue:&returnCGRect];
        
        XCTAssertTrue(returnCGRect.origin.x == 1);
        XCTAssertTrue(returnCGRect.origin.y == 2);
        XCTAssertTrue(returnCGRect.size.width == 3);
        XCTAssertTrue(returnCGRect.size.height == 4);
    }
}

- (void)test_safe_invoke {
    SEL selector;
    
    CGRect returnCGRect = CGRectZero;
    selector = @selector(returnCGRect);
    
    @try {
        if ([self respondsToSelector:selector]) {
            // exception 1: invocationWithMethodSignature: pass nil
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
            
            // exception 2: target not correct
            invocation.target = [UIScreen mainScreen];
            invocation.selector = selector;
            
            [invocation invoke];
            [invocation getReturnValue:&returnCGRect];
        }
    }
    @catch (NSException *exception) {
    }
    
    NSLog(@"%@", NSStringFromCGRect(returnCGRect));
}

#pragma mark -

- (NSUInteger)returnInteger {
    return 10;
}

- (CGRect)returnCGRect {
    return CGRectMake(1, 2, 3, 4);
}

@end
