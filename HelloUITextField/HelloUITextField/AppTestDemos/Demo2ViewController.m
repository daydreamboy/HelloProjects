//
//  Demo2ViewController.m
//  HelloUITextField
//
//  Created by wesley chen on 16/7/9.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "Demo2ViewController.h"

// MARK: center vertically UITextField's attributedPlaceholder
@interface Demo2ViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UITextField *textField3;
@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField1];
    [self.view addSubview:self.textField2];
    [self.view addSubview:self.textField3];
    
    [self.textField1 becomeFirstResponder];
}

#pragma mark - Getters

- (UITextField *)textField1 {
    if (!_textField1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * 20, 40)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:20.0f];
        
        // @note: must assign attributedPlaceholder after assigning font
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here..."
                                                                          attributes:@{
                                               NSForegroundColorAttributeName: [UIColor redColor],
                                               NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
                                           }];
        
        _textField1 = textField;
    }
    
    return _textField1;
}

- (UITextField *)textField2 {
    if (!_textField2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField1.frame) + 10, screenSize.width - 2 * 20, 40)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:20.0f];

        UIFont *textFont = [UIFont systemFontOfSize:12.0f];

        NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - textFont.lineHeight) / 2.0;

        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here..."
                                                                          attributes:@{
                                               NSForegroundColorAttributeName: [UIColor redColor],
                                               NSFontAttributeName: textFont,
                                               NSParagraphStyleAttributeName: style,
                                           }];

        _textField2 = textField;
    }

    return _textField2;
}

- (UITextField *)textField3 {
    if (!_textField3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.textField2.frame) + 10, screenSize.width - 2 * 20, 40)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:20.0f];

        // http://stackoverflow.com/questions/28677519/vertically-centering-a-uitextfields-attributedplaceholder
        UIFont *textFont = [UIFont fontWithName:@"Georgia-Italic" size:12.0];

        NSMutableParagraphStyle *style = [textField.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        style.minimumLineHeight = textField.font.lineHeight - (textField.font.lineHeight - textFont.lineHeight) / 2.0;

        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here..."
                                                                          attributes:@{
                                               NSForegroundColorAttributeName: [UIColor redColor],
                                               NSFontAttributeName: textFont,
                                               NSParagraphStyleAttributeName: style,
                                           }];

        _textField3 = textField;
    }

    return _textField3;
}

@end
