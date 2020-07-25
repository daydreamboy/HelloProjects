//
//  UseUIPanGestureRecognizer2ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 23/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseUIPanGestureRecognizer2ViewController.h"

@interface UseUIPanGestureRecognizer2ViewController ()

@end

@implementation UseUIPanGestureRecognizer2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    view.center = self.view.center;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
    [view addGestureRecognizer:panGesture];
    
    [self.view addSubview:view];
}

#pragma mark - Actions

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    // @see https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        // Note: reset translation when every UIGestureRecognizerStateChanged detected, so translation is always calculated based on CGPointZero
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
}

@end
