//
//  MappingRectFromViewToViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 13/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MappingRectFromViewToViewViewController.h"

@interface MappingRectFromViewToViewViewController ()
@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@end

@implementation MappingRectFromViewToViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.view1];
    
    NSLog(@"view3 frame In super view: %@", NSStringFromCGRect(self.view3.frame));
    
    // Note: rect from view3 to view1
    NSLog(@"view3 bounds In view1: %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:self.view1]));
    
    // Note: rect from view3 to view2
    NSLog(@"view3 bounds In view 2 (super view): %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:self.view2]));
    
    // Note: rect from self view to self view
    NSLog(@"view3 bounds In itself: %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:self.view3]));
    
    // Note: rect from view3 to UIViewController.view
    NSLog(@"view3 bounds In self.view: %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:self.view]));
    
    // Note: self.view.window is nil
    NSLog(@"self.view.window: %@", self.view.window);
    NSLog(@"view3 bounds In self.view.window: %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:self.view.window]));
    NSLog(@"view3 bounds In Window(nil): %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:nil]));
    
    // Note: rect from view3 to UIApplicationDelegate.window
    NSLog(@"view3 bounds In Window(delegate.window): %@", NSStringFromCGRect([self.view3 convertRect:self.view3.bounds toView:[UIApplication sharedApplication].delegate.window]));
}

#pragma mark - Getters


- (UIView *)view1 {
    if (!_view1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 200, 60)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        
        _view1 = view;
        
        [_view1 addSubview:self.view2];
    }
    
    return _view1;
}

- (UIView *)view2 {
    if (!_view2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        
        view.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.4];
        _view2 = view;
        
        [_view2 addSubview:self.view3];
    }
    
    return _view2;
}

- (UIView *)view3 {
    if (!_view3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 50, 10)];
        
        view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        _view3 = view;
    }
    
    return _view3;
}

@end
