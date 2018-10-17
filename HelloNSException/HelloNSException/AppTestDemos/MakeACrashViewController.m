//
//  MakeACrashViewController.m
//  HelloNSException
//
//  Created by wesley_chen on 2018/10/17.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MakeACrashViewController.h"

@interface MakeACrashViewController ()

@end

@implementation MakeACrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *nilString = nil;
    [[NSMutableArray array] addObject:nilString];
}

@end
