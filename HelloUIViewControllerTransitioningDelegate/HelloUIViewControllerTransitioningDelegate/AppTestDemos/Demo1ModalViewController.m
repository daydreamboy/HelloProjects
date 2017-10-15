//
//  Demo1ModalViewController.m
//  UIViewController+Addition
//
//  Created by wesley chen on 16/7/12.
//
//

#import "Demo1ModalViewController.h"

@interface Demo1ModalViewController ()
@property (nonatomic, strong) UIButton *buttonDismiss;
@end

@implementation Demo1ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonDismiss];
}

#pragma mark - Getters

- (UIButton *)buttonDismiss {
    if (!_buttonDismiss) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = 120.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, (screenSize.height - height) / 2.0, width, height);
        button.layer.cornerRadius = 4.0f;
        button.layer.borderColor = [UIColor darkGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.masksToBounds = YES;
        [button setTitle:@"Dismiss Me" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDismissClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonDismiss = button;
    }
    
    return _buttonDismiss;
}

- (void)buttonDismissClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
