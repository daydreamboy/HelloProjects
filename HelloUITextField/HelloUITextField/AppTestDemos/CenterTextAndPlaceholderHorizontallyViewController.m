//
//  CenterTextAndPlaceholderHorizontallyViewController.m
//  HelloUITextField
//
//  Created by wesley chen on 16/9/9.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "CenterTextAndPlaceholderHorizontallyViewController.h"

// MARK: center horizontally UITextField's text and placeholder
// @sa http://stackoverflow.com/questions/25436637/how-do-i-centre-uitextfield-cursor-after-user-input-consistently
@interface CenterTextAndPlaceholderHorizontallyViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;

@property (nonatomic, copy) NSString *placeholder;

@end

@implementation CenterTextAndPlaceholderHorizontallyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeholder = @"Type here...";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField1];
    [self.view addSubview:self.textField2];
    [self.view addSubview:self.textField3];
}

#pragma mark - Getters

- (UITextField *)textField1 {
    if (!_textField1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * 20, 30)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.placeholder = [self.placeholder copy];
        textField.textAlignment = NSTextAlignmentCenter;
        
        _textField1 = textField;
    }
    
    return _textField1;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame) + 10, screenSize.width - 2 * 20, 30)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.placeholder = [self.placeholder copy]; // override by attributedPlaceholder
        textField.textAlignment = NSTextAlignmentCenter;
        textField.attributedPlaceholder = [self createAttributedPlaceholderWithTextField:textField];
        
        _textField2 = textField;
    }
    
    return _textField2;
}

- (UITextField *)textField3 {
    if (!_textField3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame) + 10, screenSize.width - 2 * 20, 30)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.placeholder = [self.placeholder copy];
        textField.textAlignment = NSTextAlignmentCenter;
        
        _textField3 = textField;
    }
    
    return _textField3;
}

#pragma mark

- (NSAttributedString *)createAttributedPlaceholderWithTextField:(UITextField *)textField {
    UIFont *textFont = [UIFont systemFontOfSize:12.0f];
    
    NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - textFont.lineHeight) / 2.0;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[self.placeholder copy]
                                                                     attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor redColor],
                                                 NSFontAttributeName: textFont,
                                                 NSParagraphStyleAttributeName: style,
                                                 }];
    return attrString;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.textField1) {
        self.textField1.placeholder = nil;
    }
    else if (textField == self.textField2) {
        self.textField2.attributedPlaceholder = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textField1) {
        self.textField1.placeholder = self.placeholder;
    }
    else if (textField == self.textField2) {
        self.textField2.attributedPlaceholder = [self createAttributedPlaceholderWithTextField:textField];
    }
}

@end
