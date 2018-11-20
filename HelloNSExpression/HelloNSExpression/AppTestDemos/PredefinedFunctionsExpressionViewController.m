//
//  PredefinedFunctionsExpressionViewController.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/11/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "PredefinedFunctionsExpressionViewController.h"
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

@interface PredefinedFunctionsExpressionViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *predefinedFunctions;
@end

@implementation PredefinedFunctionsExpressionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _predefinedFunctions = @{
             @"Statistics" : @[
                     @"average:",
                     @"sum:",
                     @"count:",
                     @"min:",
                     @"max:",
                     @"median:",
                     @"mode:",
                     @"stddev:",
                     ],
             @"Basic Arithmetic": @[
                     @"add:to:",
                     @"from:subtract:",
                     @"multiply:by:",
                     @"divide:by:",
                     @"modulus:by:",
                     @"abs:",
                     ],
             @"Advanced Arithmetic": @[
                     @"sqrt:",
                     @"log:",
                     @"ln:",
                     @"raise:toPower:",
                     @"exp:",
                     ],
             @"Bounding Functions": @[
                     @"ceiling:",
                     @"trunc:",
                     ],
             @"Functions Shadowing math.h Functions": @[
                     @"floor:",
                     ],
             @"Random Functions": @[
                     @"random",
                     @"random:",
                     ],
             @"Binary Arithmetic": @[
                     @"bitwiseAnd:with:",
                     @"bitwiseOr:with:",
                     @"bitwiseXor:with:",
                     @"leftshift:by:",
                     @"rightshift:by:",
                     @"onesComplement:",
                     ],
             @"Date Functions": @[
                     @"now",
                     ],
             @"String Functions": @[
                     @"lowercase:",
                     @"uppercase:",
                     ],
             @"No-op": @[
                     @"noindex:",
                     ],
             @"#Custom Functions": @[
                     @"factorial",
                     @"squareAndSubtractFive",
                     @"gaussianWithMean:andVariance:",
                     @"characterStringAtIndex:",
                     @"concatString:",
                     ],
        };
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.pickerView];
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
        textField.placeholder = @"1, 2, 3, 4, 4, 5, 9, 11";
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        
        _textField = textField;
    }
    
    return _textField;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, CGRectGetMaxY(_textField.frame) + 10, screenSize.width, CGRectGetHeight(_pickerView.bounds));
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    }
    
    return _pickerView;
}

#pragma mark -

- (NSString *)functionStringInPickerView {
    NSString *functionString;
    if ([self.pickerView selectedRowInComponent:0] != -1) {
        NSString *key = [[self.predefinedFunctions allKeys] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
        NSArray *functionNames = [self.predefinedFunctions objectForKey:key];
        if ([self.pickerView selectedRowInComponent:1] != -1) {
            functionString = [functionNames objectAtIndex:[self.pickerView selectedRowInComponent:1]];
        }
    }
    return functionString;
}

#pragma mark - UITextFieldDelegate

#define ConstantExp(x) ([NSExpression expressionForConstantValue:(x)])

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSNumber *resultValue;
    NSString *functionString = [self functionStringInPickerView];
    
    BOOL isStringFunction = NO;
    BOOL isCustomFunction = [self.predefinedFunctions[@"#Custom Functions"] containsObject:functionString];;
    
    @try {
        NSExpression *expression;
        NSMutableArray *arguments = [NSMutableArray array];
        
        if (isCustomFunction) {
            NSArray *numberStrings = [self.textField.text componentsSeparatedByString:@","];
            
            NSArray *ranges = [WCStringTool rangesOfSubstringWithString:functionString substring:@":"];
            // Note: use `FUNCTION` or `function` both OK
            NSMutableString *formatString = [NSMutableString stringWithString:@"FUNCTION("];
            
            for (NSInteger i = 0; i < ranges.count + 1 && i < numberStrings.count; i++) {
                if (i == 0) {
                    [formatString appendFormat:@"%@, '%@'", numberStrings[i], functionString];
                }
                else {
                    [formatString appendFormat:@", %@", numberStrings[i]];
                }
            }
            
            [formatString appendString:@")"];
            
            expression = [NSExpression expressionWithFormat:formatString];
        }
        else {
            BOOL isStatisticFunction = [self.predefinedFunctions[@"Statistics"] containsObject:functionString];
            if (isStatisticFunction) {
                NSArray *numberStrings = [self.textField.text componentsSeparatedByString:@","];
                NSMutableArray<NSNumber *> *numbers = [NSMutableArray arrayWithCapacity:numberStrings.count];
                for (NSString *numberString in numberStrings) {
                    [numbers addObject:@([numberString doubleValue])];
                }
                
                [arguments addObject:ConstantExp(numbers)];
            }
            else {
                isStringFunction = [self.predefinedFunctions[@"String Functions"] containsObject:functionString];
                
                if (isStringFunction) {
                    NSArray *strings = [self.textField.text componentsSeparatedByString:@","];
                    
                    NSString *firstString = [strings firstObject];
                    if (firstString) {
                        [arguments addObject:ConstantExp(firstString)];
                    }
                }
                else {
                    NSArray *numberStrings = [self.textField.text componentsSeparatedByString:@","];
                    NSMutableArray<NSNumber *> *numbers = [NSMutableArray arrayWithCapacity:numberStrings.count];
                    for (NSString *numberString in numberStrings) {
                        [numbers addObject:@([numberString doubleValue])];
                    }
                    
                    NSArray *ranges = [WCStringTool rangesOfSubstringWithString:functionString substring:@":"];
                    for (NSInteger i = 0; i < ranges.count && i < numbers.count; i++) {
                        [arguments addObject:ConstantExp(numbers[i])];
                    }
                }
            }
            
            expression = [NSExpression expressionForFunction:functionString arguments:arguments];
        }
        
        resultValue = [expression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
        NSString *msg = [NSString stringWithFormat:@"%@", e];
        ALERT_TIP(@"Whoop!", msg, @"Ok", nil);
        return NO;
    }
    
    if ([resultValue isKindOfClass:[NSNumber class]] ||
        ([functionString isEqualToString:@"mode:"] && [resultValue isKindOfClass:[NSArray class]]) ||
        ([functionString isEqualToString:@"now"] && [resultValue isKindOfClass:[NSDate class]]) ||
        (isStringFunction && [resultValue isKindOfClass:[NSString class]]) ||
        isCustomFunction) {
        NSString *msg = [NSString stringWithFormat:@"%@", resultValue];
        ALERT_TIP(@"Got Result!", msg, @"Ok", nil);
    }
    else {
        NSString *msg = [NSString stringWithFormat:@"%@", resultValue];
        ALERT_TIP(@"Some error happened", msg, @"Ok", nil);
    }
    
    return NO;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSString *key = [[self.predefinedFunctions allKeys] objectAtIndex:row];
        return key;
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *key = [[self.predefinedFunctions allKeys] objectAtIndex:index];
        NSArray *value = self.predefinedFunctions[key];
        return value[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [[self.predefinedFunctions allKeys] count];
    }
    else {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        NSString *key = [[self.predefinedFunctions allKeys] objectAtIndex:index];
        NSArray *value = self.predefinedFunctions[key];
        return value.count;
    }
}

@end
