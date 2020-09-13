//
//  CustomPresentationViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2018/10/31.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CustomPresentationViewController.h"
#import "DummyModalViewController.h"

@interface CustomPresentationViewController ()
@property (nonatomic, strong) UIButton *buttonPresent;
@end

@implementation CustomPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonPresent];
}


#pragma mark - Getters

- (UIButton *)buttonPresent {
    if (!_buttonPresent) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 140.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, 120, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Present" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPresentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonPresent = button;
    }
    
    return _buttonPresent;
}

#pragma mark - Actions

- (void)buttonPresentClicked:(id)sender {
    // @sa http://stackoverflow.com/questions/8999953/animate-presentmodalviewcontroller-from-right-left
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.duration = 5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self.navigationController presentViewController:[DummyModalViewController new] animated:NO completion:nil];
    
    //[self.navigationController presentViewController:[DummyModalViewController new] animated:YES completion:nil];
}

@end
