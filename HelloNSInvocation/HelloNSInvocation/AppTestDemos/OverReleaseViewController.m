//
//  OverReleaseViewController.m
//  HelloNSInvocation
//
//  Created by wesley_chen on 2019/12/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "OverReleaseViewController.h"

@interface OverReleaseViewController ()

@end

@implementation OverReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_over_release];
}

- (void)test_over_release {
//    @autoreleasepool {
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
//    }
}

- (NSString *)concatStringWithStringA:(NSString *)stringA stringB:(NSString *)stringB {
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:stringA];
    [stringM appendString:stringB];
    
    return stringM;
}

@end
