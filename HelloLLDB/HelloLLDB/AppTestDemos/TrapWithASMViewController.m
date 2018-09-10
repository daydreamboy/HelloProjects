//
//  TrapWithASMViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 2018/8/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TrapWithASMViewController.h"

@interface TrapWithASMViewController ()

@end

@implementation TrapWithASMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    asm("int3");
    NSLog(@"This line still can be executed after int3");
}

@end
