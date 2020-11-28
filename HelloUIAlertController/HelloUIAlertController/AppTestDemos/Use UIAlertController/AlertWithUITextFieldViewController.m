//
//  AlertWithUITextFieldViewController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2020/11/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "AlertWithUITextFieldViewController.h"

/**
 Show alert with a text field
 
 @param title
 @param msg
 @param _placeholder
 @param cancel
 @param dismissCompletion void (^dismissCompletion)(NSString *text)
 - text the text of input
 */
#define SHOW_ALERT_WITH_INPUT(title, msg, _placeholder, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        __block UITextField *localTextField; \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            !dismissCompletion ?: dismissCompletion(localTextField.text); \
        }]; \
        [alert addAction:cancelAction]; \
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) { \
            localTextField = textField; \
            localTextField.placeholder = _placeholder; \
        }]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

@interface AlertWithUITextFieldViewController ()

@end

@implementation AlertWithUITextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"ShowAlert" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showAlertField:nil];
}

- (void)showAlertField:(id)sender {
    // need local variable for TextField to prevent retain cycle of Alert otherwise UIWindow
    // would not disappear after the Alert was dismissed
    __block UITextField *localTextField;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Global Alert" message:@"Enter some text" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"do something with text: %@", localTextField.text);
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Action

- (void)rightItemClicked:(id)sender {
    SHOW_ALERT_WITH_INPUT(@"Alert", @"prompt", @"Input here...", @"Ok", ^(NSString *text){
        NSLog(@"text: %@", text);
    });
}

@end
