//
//  ViewController.m
//  App
//
//  Created by wesley_chen on 22/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#if __has_include("AutomaticCreated.h")
#import "AutomaticCreated.h"

#define CONFIGURATION_AVAILABLE 1

#endif

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if CONFIGURATION_AVAILABLE
    [Configuration hello];
#endif
}

@end
