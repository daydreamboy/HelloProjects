//
//  TrapWithBuiltinTrapViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 2018/8/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TrapWithBuiltinTrapViewController.h"

@interface TrapWithBuiltinTrapViewController ()

@end

@implementation TrapWithBuiltinTrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __builtin_trap();
    NSLog(@"This line will be never executed");
}

@end
