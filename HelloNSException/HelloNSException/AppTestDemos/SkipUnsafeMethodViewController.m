//
//  SkipUnsafeMethodViewController.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 09/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "SkipUnsafeMethodViewController.h"
#import "UncatchExceptionGuard.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@interface SkipUnsafeMethodViewController ()

@end

@implementation SkipUnsafeMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isBlockCalled = [UncatchExceptionGuard tryCallBlockIfNeeded:^{
        [self test_make_a_uncatch_exception];
    } forKey:NSStringFromClass([self class])];
    NSLog(@"block is called: %@", STR_OF_BOOL(isBlockCalled));
}

- (void)test_make_a_uncatch_exception {
    abort();
}

@end
