//
//  UseWCKeyboardShortcutManagerViewController.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseWCKeyboardShortcutManagerViewController.h"
#import "WCKeyboardShortcutManager.h"

@interface UseWCKeyboardShortcutManagerViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@end

@implementation UseWCKeyboardShortcutManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.label];
    
    [self installShortcuts];
}

#pragma mark - Getter

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 30)];
        textField.layer.cornerRadius = 2.0f;
        textField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
        textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
        textField.placeholder = @"Typing here...";
        
        _textField = textField;
    }
    
    return _textField;
}

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    #if TARGET_OS_SIMULATOR
        label.text = @"Connect to hardware keyboard to test shortcuts";
    #else
        label.text = @"Test shortcuts on simulator";
    #endif
        label.textColor = [UIColor darkGrayColor];
        [label sizeToFit];
        label.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        
        _label = label;
    }
    
    return _label;
}

#pragma mark -

- (void)installShortcuts {
#if TARGET_OS_SIMULATOR
    [[WCKeyboardShortcutManager defaultManager] registerSimulatorShortcutWithKey:@"b" modifiers:0 action:^{
        [self.navigationController popViewControllerAnimated:YES];
    } description:@"Pop current view controller"];
#endif
}

@end
