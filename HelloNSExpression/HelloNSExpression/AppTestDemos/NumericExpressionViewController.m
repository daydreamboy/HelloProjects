//
//  NumericExpressionViewController.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NumericExpressionViewController.h"
#import "WCStringTool.h"

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

@interface NumericExpressionViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *labelTips;
@end

@implementation NumericExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.labelTips];
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

- (UILabel *)labelTips {
    if (!_labelTips) {
        NSString *tips = @"Tips: support sqrt, log, ln, exp,  ceiling, abs, trunc, floor. e.g. sqrt(4 + 3 - 2) + log(5)";
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.text = tips;
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        
        CGSize textSize = [WCStringTool textSizeWithMultipleLineString:tips width:(screenSize.width - 2 * padding) font:label.font mode:NSLineBreakByCharWrapping widthToFit:NO];
        label.frame = CGRectMake(padding, CGRectGetMaxY(self.textField.frame) + padding, screenSize.width - 2 * padding, textSize.height);
        
        _labelTips = label;
    }
    
    return _labelTips;
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
