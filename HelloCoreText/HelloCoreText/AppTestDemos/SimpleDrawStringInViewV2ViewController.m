//
//  SimpleDrawStringInViewV2ViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "SimpleDrawStringInViewV2ViewController.h"
#import "CTViewV2.h"

@interface SimpleDrawStringInViewV2ViewController ()

@end

@implementation SimpleDrawStringInViewV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CTViewV2 *view = [[CTViewV2 alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

@end
