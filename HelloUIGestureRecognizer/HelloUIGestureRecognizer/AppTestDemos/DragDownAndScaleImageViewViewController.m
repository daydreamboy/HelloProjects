//
//  DragDownAndScaleImageViewViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DragDownAndScaleImageViewViewController.h"

@interface DragDownAndScaleImageViewViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat dragDownOffsetThrottle;
@property (nonatomic, assign) CGPoint initialTranslation;
@end

@implementation DragDownAndScaleImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    panGesture.delegate = self;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:panGesture];
    
    self.dragDownOffsetThrottle = 10;
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"Xcode"];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = screenSize.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        imageView.image = image;
        imageView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        
        _imageView = imageView;
    }
    
    return _imageView;
}

#pragma mark - Actions

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {

    UIView *targetView = recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:targetView.superview];
        CGPoint velocity = [recognizer velocityInView:targetView];
        
        // Note: drag down image
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:targetView.superview];
        
        // Note: scale image when drag down
        CGFloat centerYOffset = (targetView.center.y - recognizer.view.superview.bounds.size.height / 2.0);
        CGFloat scale = 1.0 - centerYOffset / (recognizer.view.superview.bounds.size.height / 2.0);
        
        scale = MIN(scale, 1);
        scale = MAX(scale, 0.5);
        
        recognizer.view.transform = CGAffineTransformMakeScale(scale, scale);
    
        // DEBUG: check velocity
        NSLog(@"velocity: %@", NSStringFromCGPoint(velocity));
        
        // @see https://stackoverflow.com/a/5187591
        if (velocity.x > 0) {
            NSLog(@"gesture went right");
        }
        else {
            NSLog(@"gesture went left");
        }
        
        if (velocity.y > 0) {
            NSLog(@"gesture went down");
        }
        else {
            NSLog(@"gesture went up");
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        // @see https://stackoverflow.com/a/13879971
        [UIView animateWithDuration:0.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = CGPointMake(recognizer.view.superview.bounds.size.width / 2.0, recognizer.view.superview.bounds.size.height / 2.0);
                             recognizer.view.transform = CGAffineTransformIdentity;
                         }
                         completion:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    // @see https://stackoverflow.com/a/8603839
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    
    // Note: only allow to start to drag down (velocity.y > 0), and velocity angle is down which is < 90°
    return fabs(velocity.y) > fabs(velocity.x) && velocity.y > 0;
}

@end
