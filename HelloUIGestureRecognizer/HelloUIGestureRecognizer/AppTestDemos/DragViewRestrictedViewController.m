//
//  DragViewRestrictedViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 23/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "DragViewRestrictedViewController.h"

@interface DragViewRestrictedViewController ()
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) CGRect currentFrame;
@end

@implementation DragViewRestrictedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *view = [[UIView alloc] initWithFrame:self.initialFrame];
    view.backgroundColor = [UIColor magentaColor];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
    [view addGestureRecognizer:panGesture];
    
    [self.view addSubview:view];
}

- (void)setup {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.initialFrame = CGRectMake(0, screenSize.height - 200, screenSize.width, 200);
}

#pragma mark - Actions

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.currentFrame = targetView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [recognizer translationInView:self.view];
        
        CGRect frame = self.currentFrame;
        if (frame.origin.y + delta.y >= 64
            && frame.origin.y + delta.y <= screenSize.height - CGRectGetHeight(self.initialFrame)) {
            
            //
            frame.origin.y = frame.origin.y + delta.y;
            frame.size.height = frame.size.height - delta.y;
            
            targetView.frame = frame;
        }
    }
}


@end
