//
//  ViewController2.m
//  AppTest
//
//  Created by wesley_chen on 03/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController2.h"

@import HelloModularFramework_Submodule.PublicClassA;

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PublicClassD doSomething];
}

@end
