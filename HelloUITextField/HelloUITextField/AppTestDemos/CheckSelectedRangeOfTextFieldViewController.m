//
//  CheckSelectedRangeOfTextFieldViewController.m
//  HelloUITextField
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 chenliang-xy. All rights reserved.
//

#import "CheckSelectedRangeOfTextFieldViewController.h"
#import "WCTextFieldTool.h"
#import "WCWeakProxy.h"

@interface CheckSelectedRangeOfTextFieldViewController () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *textField;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CheckSelectedRangeOfTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:[WCWeakProxy proxyWithTarget:self] selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
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

#pragma mark - NSTimer

- (void)timerFired:(NSTimer *)timer {
    NSRange selectedRange = [WCTextFieldTool selectedRangeWithTextField:self.textField];
    NSLog(@"isEditing: %@, selectedRange: %@", self.textField.isEditing ? @"YES" : @"NO", NSStringFromRange(selectedRange));
}

#pragma mark - Action

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        [self.textField resignFirstResponder];
    }
}

@end
