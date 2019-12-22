//
//  DoubleReleaseViewController.m
//  HelloNSInvocation
//
//  Created by wesley_chen on 2019/12/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DoubleReleaseViewController.h"

@interface DoubleReleaseViewController ()

@end

@implementation DoubleReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_double_release];
}

- (void)test_double_release {
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

- (NSString *)concatStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:stringA];
    [stringM appendString:stringB];
    
    return stringM;
}

@end
