//
//  TrapWithSignalViewController.m
//  HelloLLDB
//
//  Created by wesley_chen on 2018/8/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TrapWithSignalViewController.h"

@interface TrapWithSignalViewController ()

@end

@implementation TrapWithSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    raise(SIGTRAP);
    NSLog(@"This line still can be executed after SIGTRAP");
}

@end
