//
//  UIMenuControllerKeepKeyboardShowViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UIMenuControllerKeepKeyboardShowViewController.h"
#import "HipsterLabel.h"
#import "MyTextFieldWithOverrideNexResponder.h"

@interface UIMenuControllerKeepKeyboardShowViewController ()
@property (nonatomic, strong) HipsterLabel *label;
@property (nonatomic, strong) MyTextFieldWithOverrideNexResponder *textField;
@end

@implementation UIMenuControllerKeepKeyboardShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (HipsterLabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        
        HipsterLabel *label = [[HipsterLabel alloc] initWithFrame:CGRectMake(paddingH, paddingH, screenSize.width - 2 * paddingH, 30)];
        label.text = @"This is a label with context menu";
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPressed:)];
        [label addGestureRecognizer:longPressGesture];
        
        _label = label;
        
    }
    
    return _label;
}

- (MyTextFieldWithOverrideNexResponder *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        
        MyTextFieldWithOverrideNexResponder *textField = [[MyTextFieldWithOverrideNexResponder alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label.frame) + 10, screenSize.width - 2 * paddingH, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"Type here ...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark - Actions

- (void)labelLongPressed:(UILongPressGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    UIView *targetSuperView = targetView.superview;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (targetView && targetSuperView) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            
            if (!menuController.menuVisible) {
                [menuController setTargetRect:targetView.frame inView:targetSuperView];
                
                UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"CustomAction" action:@selector(copy:)];
                menuController.menuItems = @[ menuItemCopy ];
                
                if ([self.textField isFirstResponder]) {
                    self.textField.overrideNextResponder = self.label;
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuControllerDidHideMenuNotification:) name:UIMenuControllerDidHideMenuNotification object:nil];
                    
                    NSLog(@"change nextResponder for textField");
                }
                else {
                    BOOL success = [targetView becomeFirstResponder];
                    NSLog(@"becomeFirstResponder: %@", success ? @"YES" : @"NO");
                }
                
                [menuController setMenuVisible:YES animated:YES];
            }
        }
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

#pragma mark - NSNotfication

- (void)handleMenuControllerDidHideMenuNotification:(NSNotification*)notification {
    NSLog(@"menuDidHide");
    self.textField.overrideNextResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

@end
