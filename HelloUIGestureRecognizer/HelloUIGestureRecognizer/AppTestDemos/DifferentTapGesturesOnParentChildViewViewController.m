//
//  DifferentTapGesturesOnParentChildViewViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DifferentTapGesturesOnParentChildViewViewController.h"

@interface MyParentView : UIView

@end

@implementation MyParentView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}

@end

@interface DifferentTapGesturesOnParentChildViewViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) MyParentView *parentView;
@property (nonatomic, strong) UIView *childView;
@end

@implementation DifferentTapGesturesOnParentChildViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.parentView];
    [self.parentView addSubview:self.childView];
}

#pragma mark - Getters

- (UIView *)parentView {
    if (!_parentView) {
        MyParentView *view = [[MyParentView alloc] initWithFrame:CGRectMake(0, 60, 200, 200)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(parentViewTapped:)];
        tapGesture.cancelsTouchesInView = NO;
        tapGesture.delegate = self;
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
        tapGesture.cancelsTouchesInView = NO;
        tapGesture.delegate = self;
        [view addGestureRecognizer:tapGesture];
        _childView = view;
    }
    
    return _childView;
}

#pragma mark - Actions

- (void)parentViewTapped:(UITapGestureRecognizer *)recogizer {
    NSLog(@"parentViewTapped");
}

- (void)childViewTapped:(UITapGestureRecognizer *)recogizer {
    NSLog(@"childViewTapped");
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@ should begin", gestureRecognizer.view);
    return YES;
}

@end
