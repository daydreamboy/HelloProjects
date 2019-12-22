//
//  Tests_doubleRelease.m
//  Tests
//
//  Created by wesley_chen on 2019/12/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_doubleRelease : XCTestCase

@end

@implementation Tests_doubleRelease

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_double_release {
    @autoreleasepool {
        id returnObject = nil;
        SEL selector = @selector(concatStringWithStringA:stringB:);
        id arg1 = @"A";
        id arg2 = @"B";
        
        if ([self respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
            invocation.target = self;
            invocation.selector = selector;
            
            [invocation setArgument:&arg1 atIndex:2];
            [invocation setArgument:&arg2 atIndex:3];
            
            [invocation invoke];
            [invocation getReturnValue:&returnObject];
        }
    }
}

- (void)test_double_release_fixed {
    // @see https://stackoverflow.com/a/22034059
    @autoreleasepool {
        id __unsafe_unretained tempReturnObject = nil;
        SEL selector = @selector(concatStringWithStringA:stringB:);
        id arg1 = @"A";
        id arg2 = @"B";
        
        if ([self respondsToSelector:selector]) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
            invocation.target = self;
            invocation.selector = selector;
            
            [invocation setArgument:&arg1 atIndex:2];
            [invocation setArgument:&arg2 atIndex:3];
            
            [invocation invoke];
            [invocation getReturnValue:&tempReturnObject];
            
            id returnObject = tempReturnObject;
            NSLog(@"%@", returnObject);
        }
    }
}

- (NSString *)concatStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:stringA];
    [stringM appendString:stringB];
    
    return stringM;
}

@end
