//
//  UseStaticFrameworkViewController.m
//  AwesomeSDK_Example
//
//  Created by wesley_chen on 29/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "UseStaticFrameworkViewController.h"
#import <AwesomeSDK_static_framework/AwesomeSDKManager.h>

@interface UseStaticFrameworkViewController ()

@end

@implementation UseStaticFrameworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AwesomeSDKManager doSomething];
}

@end
