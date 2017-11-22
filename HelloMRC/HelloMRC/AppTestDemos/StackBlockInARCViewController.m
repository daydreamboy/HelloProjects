//
//  StackBlockInARCViewController.m
//  HelloMRC
//
//  Created by wesley_chen on 22/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "StackBlockInARCViewController.h"

@interface StackBlockInARCViewController ()

@end

@implementation StackBlockInARCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Note: __NSGlobalBlock__
    void (^blockA)(int a, int b) = ^(int a, int b){
        NSLog(@"a + b = %ld", (long)(a + b));
    };
    NSLog(@"blockA: %@", blockA);
    
    // Note: __NSStackBlock__
    int base = 10;
    void (^blockB)(int a, int b) = ^(int a, int b){
        NSLog(@"a + b + c = %ld", (long)(a + b + base));
    };
    NSLog(@"blockB: %@", blockB);
    
    // Note: __NSMallocBlock__
    void (^blockC)(int a, int b) = [blockB copy];
    NSLog(@"blockC: %@", blockC);
    
    // Note: __NSStackBlock__
    __block int sum = 10;
    void (^blockD)(int a, int b) = ^(int a, int b){
        sum += (a + b);
    };
    NSLog(@"blockD: %@", blockD);
}

@end
