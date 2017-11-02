//
//  ViewController.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import "ViewController2.h"

// use the following lines  to access PublicClassB
//#import <HelloModularFramework_Submodule/PublicClassC.h>
//#import <HelloModularFramework_Submodule/PublicClassB.h>

@import HelloModularFramework_Submodule.PublicClassC;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PublicClassC doSomething];
    
    // Error: module `PublicClassC` can't provide `PublicClassB` class,
    // but use
    // #import <HelloModularFramework_Submodule/PublicClassC.h>
    // #import <HelloModularFramework_Submodule/PublicClassB.h>
    // can overcome this error
    //[PublicClassB doSomething];
}

@end
