//
//  ViewController.m
//  HelloSubFrameworks
//
//  Created by wesley_chen on 26/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ViewController.h"
//#import <SubFramework1/SubFramework1Manager.h>
#import "SubFramework1Manager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SubFramework1Manager *manager1 = [SubFramework1Manager new];
    [manager1 doSomething];
}

@end
