//
//  TrapWithASMViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 2018/8/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TrapWithASMViewController.h"

// @see https://github.com/opensource-apple/CF/blob/3cc41a76b1491f50813e28a4ec09954ffa359e6f/CFInternal.h#L145
#if defined(__i386__) || defined(__x86_64__)
    #if defined(__GNUC__)
        #define HALT do {asm __volatile__("int3"); kill(getpid(), 9); __builtin_unreachable(); } while (0)
    #elif defined(_MSC_VER)
        #define HALT do { DebugBreak(); abort(); __builtin_unreachable(); } while (0)
    #else
        #error Compiler not supported
    #endif
#else
    #define HALT
#endif

@interface TrapWithASMViewController ()

@end

@implementation TrapWithASMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test2];
}

- (void)test1 {
#if defined(__i386__) || defined(__x86_64__)
    asm("int3");
    NSLog(@"This line still can be executed after int3");
#endif
}

- (void)test2 {
    HALT;
}

@end
