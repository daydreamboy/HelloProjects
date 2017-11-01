//
//  ViewController.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"

//#import <HelloModularFramework_CustomizedModular/HelloModularFramework_CustomizedModular.h>
@import HelloModularFramework_CustomizedModular;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PublicClassA doSomething];
    [PublicClassB doSomething];
}

@end
