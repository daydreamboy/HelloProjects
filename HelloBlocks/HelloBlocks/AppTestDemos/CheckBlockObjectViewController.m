//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CheckBlockObjectViewController.h"
#import "WCBlockTool.h"
#import "GlobalAndMallocBlocks.h"
#import "StackBlocks.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@implementation CheckBlockObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_isBlock_with_gloabl_blocks];
    [self test_isBlock_with_malloc_blocks];
    [self test_isBlock_with_stack_blocks];
}

#pragma mark - Test Methods

- (void)test_isBlock_with_gloabl_blocks {
    id aBlock = nil;
    
    aBlock = [GlobalBlocks block1];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [GlobalBlocks block2];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [GlobalBlocks block3];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [GlobalBlocks block4];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [GlobalBlocks block5];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
}

- (void)test_isBlock_with_malloc_blocks {
    id aBlock = nil;
    
    aBlock = [MallocBlocks block1];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [MallocBlocks block2];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    aBlock = [MallocBlocks block3];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
}

- (void)test_isBlock_with_stack_blocks {
    [StackBlocks test_isBlock_with_stack_blocks];
}

@end
