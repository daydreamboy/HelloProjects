//
//  ViewController.m
//  HelloIssueUI_layoutSubviewsWithCenter
//
//  Created by wesley_chen on 11/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import "Subview.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self test_layoutSubviews_will_be_called];
//    [self test_issue_of_layoutSubview_with_setCenter];
    [self test_issue_of_layoutSubview_with_setCenter_fixed];
}

- (void)test_layoutSubviews_will_be_called {
    // Note: those init are all Ok
    //  - [[Subview alloc] init]
    //  - [[Subview alloc] initWithFrame:CGRectZero]
    //  - [[Subview alloc] initWithFrame:CGRectMake(...)]
    Subview *view = [[Subview alloc] initWithFrame:CGRectZero];
    
    // Note: will make `layoutSubviews` called
    [self.view addSubview:view];
    view.backgroundColor = [UIColor yellowColor];
}

- (void)test_issue_of_layoutSubview_with_setCenter {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // Note: those init are all NOT Ok
    //  - [[Subview alloc] init]
    //  - [[Subview alloc] initWithFrame:CGRectZero]
    //  - [[Subview alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]
    //  - [[Subview alloc] initWithFrame:CGRectMake(10, 10, 0, 0)]
    Subview *view = [[Subview alloc] init];
    
    // Note: setCenter will cause `layoutSubviews` NOT called
    view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:view];
    view.backgroundColor = [UIColor yellowColor];
}

- (void)test_issue_of_layoutSubview_with_setCenter_fixed {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // Note: frame must have non-zero width/height
    Subview *view = [[Subview alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:view];
    view.backgroundColor = [UIColor yellowColor];
}

@end
