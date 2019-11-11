//
//  ShowCustomViewSafeAreaViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ShowCustomViewSafeAreaViewController.h"
#import "TouchView.h"

@interface ShowCustomViewSafeAreaViewController ()
@property (nonatomic, assign) CGPoint touchViewPositionValue;
@property (nonatomic, assign) CGPoint touchViewPositionOffset;
@property (nonatomic, strong) TouchView *touchView;
@property (nonatomic, assign) BOOL needUpdateTouchViewPosition;
@end

@implementation ShowCustomViewSafeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.touchView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self layoutTouchView];
}

- (void)layoutTouchView {
    if (CGPointEqualToPoint(self.touchViewPositionValue, CGPointZero)) {
        self.touchViewPositionValue = self.view.center;
    }
    
    self.touchView.center = self.touchViewPositionValue;
}

#pragma mark - Getter

- (TouchView *)touchView {
    if (!_touchView) {
        TouchView *view = [[TouchView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewPanned:)];
        [view addGestureRecognizer:panGesture];
        
        _touchView = view;
    }
    
    return _touchView;
}

#pragma mark - Action

- (void)touchViewPanned:(id)sender {
    UIPanGestureRecognizer *recognizer = sender;
    CGPoint location = [recognizer locationInView:recognizer.view.superview];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.needUpdateTouchViewPosition = CGRectContainsPoint(self.touchView.frame, location);
            self.touchViewPositionOffset = CGPointMake(location.x - self.touchView.center.x, location.y - self.touchView.center.y);
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            self.needUpdateTouchViewPosition = NO;
            self.touchViewPositionOffset = CGPointZero;
            break;
        }
        default: {
            if (self.needUpdateTouchViewPosition) {
                self.touchViewPositionValue = CGPointMake(location.x - self.touchViewPositionOffset.x, location.y - self.touchViewPositionOffset.y);
                [self layoutTouchView];
            }
            break;
        }
    }
}

@end
