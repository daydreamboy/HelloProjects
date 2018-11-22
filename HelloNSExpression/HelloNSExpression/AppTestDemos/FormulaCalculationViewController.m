//
//  FormulaCalculationViewController.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/22.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "FormulaCalculationViewController.h"
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

#define STR_TRIM(str) ([(str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])

@interface FormulaCalculationViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textFieldFormula;
@property (nonatomic, strong) UITextField *textFieldVariable;
@property (nonatomic, strong) UILabel *labelTips;
@end

@implementation FormulaCalculationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textFieldFormula];
    [self.view addSubview:self.labelTips];
    [self.view addSubview:self.textFieldVariable];
}

#pragma mark - Getters

- (UITextField *)textFieldFormula {
    if (!_textFieldFormula) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(padding, padding, screenSize.width - 2 * padding, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.placeholder = @"12.845 * x + (y)";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        _textFieldFormula = textField;
    }
    
    return _textFieldFormula;
}

- (UILabel *)labelTips {
    if (!_labelTips) {
        NSString *tips = @"Tips: support sqrt, log, ln, exp,  ceiling, abs, trunc, floor. e.g. sqrt(x + y)";
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.numberOfLines = 0;
        label.text = tips;
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.2];
        
        CGSize textSize = [WCStringTool textSizeWithMultipleLineString:tips width:(screenSize.width - 2 * padding) font:label.font mode:NSLineBreakByCharWrapping widthToFit:NO];
        label.frame = CGRectMake(padding, CGRectGetMaxY(self.textFieldFormula.frame) + padding, screenSize.width - 2 * padding, textSize.height);
        
        _labelTips = label;
    }
    
    return _labelTips;
}

- (UITextField *)textFieldVariable {
    if (!_textFieldVariable) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(padding, padding + CGRectGetMaxY(self.labelTips.frame), screenSize.width - 2 * padding, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.placeholder = @"x = 12.0, y = -0.505940";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        _textFieldVariable = textField;
    }
    
    return _textFieldVariable;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSNumber *number;
    
    @try {
        NSMutableDictionary *variables = [NSMutableDictionary dictionary];
        NSArray *parts = [self.textFieldVariable.text componentsSeparatedByString:@","];
        for (NSInteger i = 0; i < parts.count; i++) {
            NSString *equationString = STR_TRIM(parts[i]);
            NSArray *keyValuePair = [equationString componentsSeparatedByString:@"="];
            if (keyValuePair.count == 2) {
                NSString *key = STR_TRIM(keyValuePair[0]);
                NSString *value = STR_TRIM(keyValuePair[1]);
                if (key.length && value.length) {
                    variables[key] = @([value doubleValue]);
                }
            }
        }
        
        NSExpression *mathExpression = [NSExpression expressionWithFormat:self.textFieldFormula.text];
        number = [mathExpression expressionValueWithObject:variables context:nil];
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
