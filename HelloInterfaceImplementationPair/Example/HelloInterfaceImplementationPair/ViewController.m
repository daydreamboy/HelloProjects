//
//  ViewController.m
//  HelloInterfaceImplementationPair
//
//  Created by daydreamboy on 07/12/2017.
//  Copyright (c) 2017 daydreamboy. All rights reserved.
//

#import "ViewController.h"
#import <MyTinySDK/MyTinySDK.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<InterfaceProtocol> obj1 = [Interface sharedManager];
    obj1.someString = @"Hello";
    obj1.numberInteger = 2017;
    NSLog(@"%@ %@, %d!", obj1.someString, obj1.readonlyString, (int)obj1.numberInteger);
    
    if (obj1.helloBlock) {
        obj1.helloBlock();
    }
    else {
        [obj1 setHelloBlock:^{
            NSLog(@"Hello, World!");
        }];
        obj1.helloBlock();
    }
    
    [obj1 helloToPersion:@"John"]; // Note: nothing to print
    [obj1 setHelloWhoBlock:^(NSString *who) {
        NSLog(@"Hello, %@", who);
    }];
    [obj1 helloToPersion:@"Lily"];
    
    id<InterfaceProtocol> obj2 = [Interface managerWithStyle:InterfaceStyle2];
    [obj2 setHelloWhoBlock:^(NSString *who) {
        NSLog(@"Hello, %@", who);
    }];
    [obj2 helloToPersion:@"Lily"];
}

@end
