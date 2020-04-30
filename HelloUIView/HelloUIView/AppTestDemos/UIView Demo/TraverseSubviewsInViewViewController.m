//
//  TraverseSubviewsInViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TraverseSubviewsInViewViewController.h"
#import "WCViewTool.h"
#import "AppDelegate.h"

@interface TraverseSubviewsInViewViewController ()

@end

@implementation TraverseSubviewsInViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    id currentViewController = [self.view holdingViewController];
    //    NSLog(@"self: %@, viewController: %@", self, currentViewController);
    //    NSAssert(self == currentViewController, @"check here");
    //
    //    id navController = [self.navigationController.navigationBar holdingViewController];
    //    NSLog(@"self.navigationController: %@, %@", self.navigationController, navController);
    //    NSAssert(self.navigationController == navController, @"check here");
    
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    id notAViewController = [window holdingViewController];
//    NSAssert(notAViewController == nil, @"check here");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // be careful when view hierarchy is changing (addSubview or removeFromSuperview...)
    __block  BOOL hasCalled = NO;
    [WCViewTool enumerateSubviewsInView:self.view enumerateIncludeView:NO usingBlock:^(UIView *subview, BOOL *stop) {
        NSLog(@"%@", subview);
        hasCalled = YES;
    }];
    
    if (!hasCalled) {
        NSLog(@"self.view has no subviews");
    }
    
    __block NSUInteger count = 0;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WCViewTool enumerateSubviewsInView:appDelegate.window enumerateIncludeView:NO usingBlock:^(UIView *subview, BOOL *stop) {
        NSLog(@"%@", subview);
        count++;
    }];
    
    NSLog(@"=====================================");
    [WCViewTool enumerateSubviewsInView:appDelegate.window enumerateIncludeView:NO usingBlock:^(UIView *subview, BOOL *stop) {
        NSLog(@"%@", subview);
        if (subview == self.view) {
            NSLog(@"found self.view");
            *stop = YES;
        }
    }];
    
    //    NSUInteger numberOfSubviews = ;
    //    NSAssert(count == numberOfSubviews, @"%@ is not equal to %@", @(count), @(numberOfSubviews));
    
    //    [appDelegate.window hierarchalDescription];
}

@end
