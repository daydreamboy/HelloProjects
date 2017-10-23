//
//  DetectSwipeUsingUIPanGestureRecognizerViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 23/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DetectSwipeUsingUIPanGestureRecognizerViewController.h"

@interface DetectSwipeUsingUIPanGestureRecognizerViewController ()
@property (nonatomic, assign) CGPoint center;
@end

@implementation DetectSwipeUsingUIPanGestureRecognizerViewController

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

#define SWIPE_LEFT_THRESHOLD    -1000.0f
#define SWIPE_RIGHT_THRESHOLD   1000.0f
#define SWIPE_UP_THRESHOLD      -200.0f
#define SWIPE_DOWN_THRESHOLD    200.0f

#pragma mark - Actions

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.center = targetView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Note: use UIPanGestureRecognizer other than UISwipeGestureRecognizer is more convenience to control threshold values
        CGPoint velocity = [recognizer velocityInView:recognizer.view];
        NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
        
        if (velocity.x < SWIPE_LEFT_THRESHOLD) {
            NSLog(@"swipe left");
        }
        else if (velocity.x > SWIPE_RIGHT_THRESHOLD) {
            NSLog(@"swipe right");
        }
        else if (velocity.y < SWIPE_UP_THRESHOLD) {
            NSLog(@"swipe up");
        }
        else if (velocity.y > SWIPE_DOWN_THRESHOLD) {
            NSLog(@"swipe down");
        }
        else {
            // TODO:
            // Here, the user lifted the finger/fingers but didn't swipe.
            // If you need you can implement a snapping behaviour, where based on the location of your         targetView,
            // you focus back on the targetView or on some next view.
            // It's your call
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:targetView];
        targetView.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    }
}

@end
