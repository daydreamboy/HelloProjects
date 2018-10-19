//
//  NSArray_initWithObjects_ViewController.m
//  HelloIssueMemoryCrash_Samples
//
//  Created by wesley_chen on 2018/10/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSArray_initWithObjects_ViewController.h"

typedef void(^myBlock)(void);

@interface NSArray_initWithObjects_ViewController ()

@end

@implementation NSArray_initWithObjects_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Sample from https://stackoverflow.com/questions/35822645/understand-one-edge-case-of-block-memory-management-in-objc
    //[self test_crash_caused_by_NSStackBlock];
    //[self test_crash_caused_by_invalid_object];
    
    // Fixed
    //[self test_crash_caused_by_NSStackBlock_fixed];
    [self test_crash_caused_by_invalid_object_fixed];
}

#pragma mark - Case 1

- (void)test_crash_caused_by_NSStackBlock {
    NSArray *tmp = [self getBlockArray1];
    myBlock block = [tmp[0] copy];
    block();
    // Crash when out of this function
    //
    // NSStackBlock is over release:
    // first time, getBlockArray1 stack frame is cleaned
    // second time, NSArray object is released, so crash here
}

- (id)getBlockArray1 {
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
            ^{NSLog(@"blk1:%d", val);}, // NSStackBlock, which cause the crash
            nil];
}

#pragma mark - Case 2

- (void)test_crash_caused_by_invalid_object {
    NSArray *tmp = [self getBlockArray2];
    myBlock block = [tmp[2] copy]; // Crash: EXC_BAD_ACCESS
    block();
}

- (id)getBlockArray2 {
    int val = 10;
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
            ^{NSLog(@"blk1:%d", val);}, // NSStackBlock
            ^{NSLog(@"blk2:%d", val);}, // id, but invalid object
            nil];
}

#pragma mark - Case 1 (Fixed)

- (void)test_crash_caused_by_NSStackBlock_fixed {
    NSArray *tmp = [self getBlockArray1_fixed];
    myBlock block = [tmp[0] copy];
    block();
}

- (id)getBlockArray1_fixed {
    int val = 10;
    return @[
             ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
             ^{NSLog(@"blk1:%d", val);}, // NSMallocBlock
             ];
}

#pragma mark - Case 2 (Fixed)

- (void)test_crash_caused_by_invalid_object_fixed {
    NSArray *tmp = [self getBlockArray2_fixed];
    myBlock block = [tmp[2] copy];
    block();
}

- (id)getBlockArray2_fixed {
    int val = 10;
    return @[
             ^{NSLog(@"blk0:%d", val);}, // NSMallocBlock
             ^{NSLog(@"blk1:%d", val);}, // NSMallocBlock
             ^{NSLog(@"blk2:%d", val);}, // NSMallocBlock
             ];
}

@end
