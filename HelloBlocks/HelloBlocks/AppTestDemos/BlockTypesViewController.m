//
//  BlockTypesViewController.m
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "BlockTypesViewController.h"
#import "MallocBlocks.h"
#import "GlobalBlocks.h"
#import "StackBlocks.h"

@interface BlockTypesViewController ()

@end

@implementation BlockTypesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_global_blocks];
    [self test_malloc_blocks];
    [self test_stack_blocks];
}

#pragma mark - Test Methods

- (void)test_global_blocks {
    NSLog(@"Global blocks-----------------------");
    NSLog(@"1. %@", [GlobalBlocks block1]);
    NSLog(@"2. %@", [GlobalBlocks block2]);
    NSLog(@"3. %@", [GlobalBlocks block3]);
    NSLog(@"4. %@", [GlobalBlocks block4]);
    NSLog(@"5. %@", [GlobalBlocks block5]);
    NSLog(@"\n");
}

- (void)test_malloc_blocks {
    NSLog(@"Malloc blocks-----------------------");
    NSLog(@"1. %@", [MallocBlocks block1]);
    NSLog(@"2. %@", [MallocBlocks block2]);
    NSLog(@"3. %@", [MallocBlocks block3]);
    NSLog(@"\n");
}

- (void)test_stack_blocks {
    NSLog(@"In MRC-----------------------");
    [StackBlocks test_block1];
    [StackBlocks test_block2];
    [StackBlocks test_block3];
    [StackBlocks test_block4];
    [StackBlocks test_block5];
    [StackBlocks test_block6];
    
    // Crash: EXC_BAD_ACCESS for __NSStackBlock__
    //NSLog(@"%@", [StackBlocks test_block1]);
    NSLog(@"\n");
}

@end
