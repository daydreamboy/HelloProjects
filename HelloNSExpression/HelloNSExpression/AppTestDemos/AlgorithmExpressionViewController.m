//
//  AlgorithmExpressionViewController.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AlgorithmExpressionViewController.h"

#define ALERT_TIP(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

@interface AlgorithmExpressionViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@end

@implementation AlgorithmExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(padding, padding, screenSize.width - 2 * padding, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.placeholder = @"4 + 5 - 2**3";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSNumber *number;
    
    @try {
        NSExpression *mathExpression = [NSExpression expressionWithFormat:self.textField.text];
        number = [mathExpression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
        NSString *msg = [NSString stringWithFormat:@"%@", e];
        ALERT_TIP(@"Whoop!", msg, @"Ok", nil);
        return NO;
    }
    
    if ([number isKindOfClass:[NSNumber class]]) {
        NSString *msg = [NSString stringWithFormat:@"%@", number];
        ALERT_TIP(@"Got Result!", msg, @"Ok", nil);
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"%@", number];
        ALERT_TIP(@"Some error happened", msg, @"Ok", nil);
    }
    
    return NO;
}

@end
