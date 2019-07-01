//
//  UseInputViewInUITextFieldViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/2/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseInputViewInUITextFieldViewController.h"
#import "WCAlertController.h"

// TODO
@interface UseInputViewInUITextFieldViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *buttonAlert;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation UseInputViewInUITextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISwitch *switcher = [[UISwitch alloc] init];
    switcher.on = NO;
    [switcher addTarget:self action:@selector(switcherToggled:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.buttonAlert];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, screenSize.width - 2 * 10, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        inputView.backgroundColor = [UIColor yellowColor];
        textField.inputView = inputView;
        textField.delegate = self;
        
        _textField = textField;
    }
    
    return _textField;
}

- (UIButton *)buttonAlert {
    if (!_buttonAlert) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame) + 10, screenSize.width, 30);
        [button setTitle:@"Show alert" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAlertClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonAlert = button;
    }
    
    return _buttonAlert;
}

#pragma mark - Actions

- (void)switcherToggled:(UISwitch *)switcher {
    switcher.on = !switcher.on;
//    [self.textField resignFirstResponder];
    if (!self.window) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.userInteractionEnabled = NO;
        window.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        [window makeKeyAndVisible];
        self.window = window;
    }
}

- (void)buttonAlertClicked:(id)sender {
    WCAlertController *alert = [WCAlertController alertControllerWithTitle:@"Attention" message:@"Nothing." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"");
    }]];
    
    [alert show];
}

- (void)viewTapped:(id)sender {
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

@end
