//
//  ViewController.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"

//#import <HelloModularFramework_Submodule/HelloModularFramework_Submodule.h>
@import HelloModularFramework_Submodule;
@import HelloModularFramework_Submodule.B;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PublicClassA doSomething];
    [PublicClassB doSomething];
}

@end
