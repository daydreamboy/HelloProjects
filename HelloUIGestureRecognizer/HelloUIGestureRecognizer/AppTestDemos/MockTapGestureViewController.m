//
//  MockTapGestureViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MockTapGestureViewController.h"
#import "WCAlertTool.h"
#import "WCGestureTool.h"

@interface MockTapGestureViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UIView *childView;
@end

@implementation MockTapGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.parentView];
    [self.parentView addSubview:self.childView];
    
    UIBarButtonItem *tapChildViewItem = [[UIBarButtonItem alloc] initWithTitle:@"Tap Child" style:UIBarButtonItemStylePlain target:self action:@selector(tapChildViewItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[tapChildViewItem];
}

#pragma mark - Getters

- (UIView *)parentView {
    if (!_parentView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 200, 200)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentViewTapped:)];
        [view addGestureRecognizer:tapGesture];
        _parentView = view;
    }
    
    return _parentView;
}

- (UIView *)childView {
    if (!_childView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childViewTapped:)];
        [view addGestureRecognizer:tapGesture];
        _childView = view;
    }
    
    return _childView;
}

#pragma mark - Actions

- (void)parentViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    CGPoint location = [recognizer locationInView:tappedView];
    
    NSString *msg = [NSString stringWithFormat:@"%@, %@", tappedView, NSStringFromCGPoint(location)];
    [WCAlertTool presentAlertWithTitle:@"parentView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    CGPoint location = [recognizer locationInView:tappedView];
    
    NSString *msg = [NSString stringWithFormat:@"%@, %@", tappedView, NSStringFromCGPoint(location)];
    [WCAlertTool presentAlertWithTitle:@"childView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

#pragma mark -

- (void)tapChildViewItemClicked:(id)sender {
    UITapGestureRecognizer *gesture = [[self.childView gestureRecognizers] firstObject];
    
    // Note: instead of call [self childViewTapped:gesture];
    [WCGestureTool triggerTapGestureWithGesture:gesture atTapPosition:CGPointZero];
}

- (UITapGestureRecognizer *)createMockTapGestureWithGesture:(UITapGestureRecognizer *)gesture {
    
    UITapGestureRecognizer *mockTapGesture = nil;
    
    NSArray *gestureRecognizerTargets = [gesture valueForKey:@"_targets"];
    NSUInteger count = 0;
    for (id gestureRecognizerTarget in gestureRecognizerTargets) {
        id target = [gestureRecognizerTarget valueForKey:@"_target"];
        
        do {
            @try {
                target = [gestureRecognizerTarget valueForKey:@"target"];
                break;
            }
            @catch (NSException *exception) {}
            
            @try {
                target = [gestureRecognizerTarget performSelector:@selector(target)];
                break;
            }
            @catch (NSException *exception) {}
        } while (NO);
        
        if (!target) {
            continue;
        }
        
        SEL action = nil;
        @try {
            NSMethodSignature *methodSignature = [gestureRecognizerTarget methodSignatureForSelector:NSSelectorFromString(@"action")];
            NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:methodSignature];
            invoke.selector = NSSelectorFromString(@"action");
            [invoke invokeWithTarget:gestureRecognizerTarget];
            [invoke getReturnValue:&action];
        }
        @catch (NSException *exception) {}
        
        if (!action) {
            continue;
        }
        
        if (count++ == 0) {
            mockTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
            mockTapGesture.numberOfTapsRequired = gesture.numberOfTapsRequired;
            mockTapGesture.numberOfTouchesRequired = gesture.numberOfTouchesRequired;
            mockTapGesture.enabled = NO;
            [gesture.view addGestureRecognizer:mockTapGesture];
        }
        else {
            [mockTapGesture addTarget:target action:action];
        }
        
        NSLog(@"%@", mockTapGesture);
    }
    
    return mockTapGesture;
}

@end
