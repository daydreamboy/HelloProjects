//
//  UseUIPanGestureRecognizer1ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 23/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "UseUIPanGestureRecognizer1ViewController.h"

@interface UseUIPanGestureRecognizer1ViewController ()
@property (nonatomic, assign) CGPoint center;
@end

@implementation UseUIPanGestureRecognizer1ViewController

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
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.center = targetView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.center = targetView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:targetView];
        targetView.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    }
}

@end
