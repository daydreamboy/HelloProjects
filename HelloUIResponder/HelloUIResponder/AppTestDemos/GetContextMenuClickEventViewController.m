//
//  GetContextMenuClickEventViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GetContextMenuClickEventViewController.h"

@interface MyTextField : UITextField
@end

@implementation MyTextField
- (void)paste:(id)sender {
    [super paste:sender];
    NSLog(@"%@ PASTE!!", self);
}
@end

@interface MyTextView : UITextView
@end

@implementation MyTextView
- (void)paste:(id)sender {
//    [super paste:sender];
    NSLog(@"%@ PASTE!!", self);
}
@end

@interface GetContextMenuClickEventViewController ()
@property (nonatomic, strong) MyTextField *textField;
@property (nonatomic, strong) MyTextView *textView;
@end

@implementation GetContextMenuClickEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.textView];
}

#pragma mark - Getters

- (MyTextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        MyTextField *textField = [[MyTextField alloc] initWithFrame:CGRectMake(10, 10, screenSize.width - 2 * 10, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField = textField;
    }
    
    return _textField;
}

- (MyTextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        MyTextView *textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.textField.frame) + 10, screenSize.width - 2 * 10, 100)];
        textView.layer.cornerRadius = 3;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _textView = textView;
    }
    
    return _textView;
}

@end
