//
//  LogicalExpressionViewController.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/20.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LogicalExpressionViewController.h"
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

// BOOL to string
#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@interface LogicalExpressionViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *labelTips;
@end

@implementation LogicalExpressionViewController

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
        textField.placeholder = @"1 + 2 > 2 || 4 - 2 = 0";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        _textField = textField;
    }
    
    return _textField;
}

- (UILabel *)labelTips {
    if (!_labelTips) {
        NSString *tips = @"Tips: support sqrt, log, ln, exp,  ceiling, abs, trunc, floor. e.g. sqrt(4 + 3 - 2) + log(5), 'abc' == 'abc'";
        
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
    BOOL result;
    
    @try {
        NSString *string = self.textField.text;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
        result = [predicate evaluateWithObject:nil];
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
        NSString *msg = [NSString stringWithFormat:@"%@", e];
        ALERT_TIP(@"Whoop!", msg, @"Ok", nil);
        return NO;
    }
    
    NSString *msg = [NSString stringWithFormat:@"%@", STR_OF_BOOL(result)];
    ALERT_TIP(@"Got Result!", msg, @"Ok", nil);

    return NO;
}

@end
