//
//  ParentViewObserveChildViewTapEventViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/4/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ParentViewObserveChildViewTapEventViewController.h"
#import "WCAlertTool.h"

@interface ParentViewObserveChildViewTapEventViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *parentViewWithMultipleChildView;
@property (nonatomic, strong) UIView *childView1;
@property (nonatomic, strong) UIView *childView2;
@property (nonatomic, strong) UIView *childView3;
@property (nonatomic, strong) UIView *childView4;
@end

@implementation ParentViewObserveChildViewTapEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.parentViewWithMultipleChildView];
}

#pragma mark - Getter

- (UIView *)parentViewWithMultipleChildView {
    if (!_parentViewWithMultipleChildView) {
        UITapGestureRecognizer *tapGesture;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 200, 200)];
        view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentViewWithMultipleChildViewTapped:)];
        tapGesture.delegate = self;
        [view addGestureRecognizer:tapGesture];
        
        _childView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _childView1.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childView1Tapped:)];
        [_childView1 addGestureRecognizer:tapGesture];
        [view addSubview:_childView1];
        
        _childView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _childView2.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childView2Tapped:)];
        [_childView2 addGestureRecognizer:tapGesture];
        [_childView1 addSubview:_childView2];
        
        _childView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _childView3.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childView3Tapped:)];
        [_childView3 addGestureRecognizer:tapGesture];
        [_childView2 addSubview:_childView3];
        
        _childView4 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 30, 30)];
        _childView4.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childView4Tapped:)];
        [_childView4 addGestureRecognizer:tapGesture];
        [_childView2 addSubview:_childView4];
        
        _parentViewWithMultipleChildView = view;
    }
    
    return _parentViewWithMultipleChildView;
}

#pragma mark - Actions

- (void)parentViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"parentView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)handleMirroredTapGesture:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    NSLog(@"handleMirroredTapGesture: %@", msg);
//    [WCAlertTool presentAlertWithTitle:@"childView tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

#pragma mark -

- (void)parentViewWithMultipleChildViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"parentViewWithMultipleChildView (blueColor) tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childView1Tapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView1 (orangeColor) tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childView2Tapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView2 (greenColor) tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childView3Tapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView3 (magentaColor) tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)childView4Tapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"childView4 (cyanColor) tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

#pragma mark -

- (void)observeChildViewTapped:(UITapGestureRecognizer *)recognizer {
    NSLog(@"-------------------");
    NSLog(@"%@", recognizer.view);
    
    if (recognizer.view == self.parentViewWithMultipleChildView) {
        NSLog(@"parentViewWithMultipleChildView (blueColor) tapped: %@", recognizer.view);
    }
    else if (recognizer.view == self.childView1) {
        NSLog(@"childView1 (orangeColor) tapped: %@", recognizer.view);
    }
    else if (recognizer.view == self.childView2) {
        NSLog(@"childView2 (greenColor) tapped: %@", recognizer.view);
    }
    else if (recognizer.view == self.childView3) {
        NSLog(@"childView3 (magentaColor) tapped: %@", recognizer.view);
    }
    else if (recognizer.view == self.childView4) {
        NSLog(@"childView4 (cyanColor) tapped: %@", recognizer.view);
    }
    NSLog(@"-------------------");
    NSLog(@"\n");
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"#### %@", gestureRecognizer.view);
    return NO;
}

@end
