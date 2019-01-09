//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "WeexInputUrlViewController.h"
#import "WeexShowCaseViewController.h"

@interface WeexInputUrlViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UITextField *textFieldUrl;
@property (nonatomic, strong) UIButton *buttonShowWeex;
@end

@implementation WeexInputUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.textFieldUrl];
    [self.view addSubview:self.buttonShowWeex];
}

#pragma mark - Getters

#define TextField_Padding_H 10

- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64 + 10, screenSize.width, 20)];
        label.text = @"Input Weex Url here";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UITextField *)textFieldUrl {
    if (!_textFieldUrl) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(TextField_Padding_H, CGRectGetMaxY(self.labelTip.frame) + 10, screenSize.width - 2 * TextField_Padding_H, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType = UIKeyboardTypeASCIICapable;
        textField.delegate = self;
        textField.placeholder = @"192.168.199.157:8081/helloweex.js";
        
        _textFieldUrl = textField;
    }
    
    return _textFieldUrl;
}

- (UIButton *)buttonShowWeex {
    if (!_buttonShowWeex) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"open url" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake((screenSize.width - CGRectGetWidth(button.bounds)) / 2.0, CGRectGetMaxY(self.textFieldUrl.frame) + CGRectGetHeight(button.bounds) / 2.0 + 10);
        [button addTarget:self action:@selector(buttonShowWeexClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonShowWeex = button;
    }
    
    return _buttonShowWeex;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textFieldUrl) {
        [self.textFieldUrl resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (void)buttonShowWeexClicked:(id)sender {
    NSString *url;
    if ([self.textFieldUrl.text hasPrefix:@"http://"] ||
        [self.textFieldUrl.text hasPrefix:@"https://"]) {
        url = self.textFieldUrl.text;
    }
    else {
        url = [NSString stringWithFormat:@"http://%@", self.textFieldUrl.text];
    }
    
    WeexShowCaseViewController *vc = [[WeexShowCaseViewController alloc] initWithWeexUrl:url];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
