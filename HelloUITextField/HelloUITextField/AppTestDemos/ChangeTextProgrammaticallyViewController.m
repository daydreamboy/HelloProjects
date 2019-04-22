//
//  ChangeTextProgrammaticallyViewController.m
//  HelloUITextField
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 chenliang-xy. All rights reserved.
//

#import "ChangeTextProgrammaticallyViewController.h"
#import "WCTextFieldTool.h"
#import "WCWeakProxy.h"

// TODO: example
@interface ChangeTextProgrammaticallyViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textField;
@end

@implementation ChangeTextProgrammaticallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    self.navigationController.navigationItem.rightBarButtonItem = rightItem;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * 20, 30)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.placeholder = @"Type here...";
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark - Action

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        [self.textField resignFirstResponder];
    }
}

- (void)rightItemClicked:(UIBarButtonItem *)sender {
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
}

@end
