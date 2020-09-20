//
//  UseNewDynamicColorViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseNewDynamicColorViewController.h"
#import "WCDynamicColorManager.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"

@interface ThemeColorProvider : NSObject <WCDynamicColorProvider>

@end

@implementation ThemeColorProvider

- (UIColor *)colorWithProviderName:(NSString *)name forKey:(NSString *)key {
    if ([name isEqualToString:@"dark"]) {
        
        NSDictionary *colors = @{
            @"label_plain_string": [UIColor redColor],
            @"label_attributed_string_1": [UIColor yellowColor],
            @"label_attributed_string_2": [UIColor magentaColor],
            @"textField_tintColor_1": [UIColor magentaColor],
            @"textField_borderColor_1": [UIColor blueColor],
        };
        
        return colors[key];
    }
    else if ([name isEqualToString:@"light"]) {
        NSDictionary *colors = @{
            @"label_plain_string": [UIColor greenColor],
            @"label_attributed_string_1": [UIColor blueColor],
            @"label_attributed_string_2": [UIColor brownColor],
            @"textField_tintColor_1": [UIColor yellowColor],
            @"textField_borderColor_1": [UIColor orangeColor],
        };
        
        return colors[key];
    }
    else if ([name isEqualToString:@"colorful 1"]) {
        NSDictionary *colors = @{
            @"label_plain_string": [UIColor orangeColor],
            @"label_attributed_string_1": [UIColor cyanColor],
            @"label_attributed_string_2": [UIColor yellowColor],
            @"textField_tintColor_1": [UIColor redColor],
            @"textField_borderColor_1": [UIColor greenColor],
        };
        
        return colors[key];
    }
    else {
        return nil;
    }
}

@end

@interface UseNewDynamicColorViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *labelPlainString;
@property (nonatomic, strong) UILabel *labelAttributedString;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *colorProviderList;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation UseNewDynamicColorViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[WCDynamicColorManager sharedManager] registerDynamicColorProvider:[ThemeColorProvider new] forName:@"light"];
        [[WCDynamicColorManager sharedManager] registerDynamicColorProvider:[ThemeColorProvider new] forName:@"dark"];
        [[WCDynamicColorManager sharedManager] registerDynamicColorProvider:[ThemeColorProvider new] forName:@"colorful 1"];
        
        self.colorProviderList = [WCDynamicColorManager sharedManager].colorProviderNames;
        
        NSInteger location = [self.colorProviderList indexOfObject:[WCDynamicColorManager sharedManager].currentColorProviderName];
        _currentIndex = location == NSNotFound ? 0 : location;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.labelPlainString];
    [self.view addSubview:self.labelAttributedString];
    [self.view addSubview:self.textField];
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItemClicked:)];
    self.navigationItem.rightBarButtonItem = nextItem;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dealloc {
    [WCDynamicColorManager removeColorDidChangeObserver:_labelAttributedString];
}

#pragma mark - Getter

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.frame = CGRectMake(0, 0, screenSize.width, CGRectGetHeight(pickerView.bounds));
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [pickerView selectRow:_currentIndex inComponent:0 animated:NO];
        
        _pickerView = pickerView;
    }
    
    return _pickerView;
}

- (UILabel *)labelPlainString {
    if (!_labelPlainString) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pickerView.frame) + 10, screenSize.width, 30)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Hello, 你好!";
        label.textColor = [WCDynamicColorManager dynamicColorWithDefaultColor:[UIColor blueColor] forKey:@"label_plain_string" attachToObject:label colorWillChangeBlock:nil];
        
        // Note: iOS 11-, call setNeedDisplay not refresh textColor
        /*
        __weak typeof(label) weak_label = label;
        if (!IOS12_OR_LATER) {
            [WCDynamicColorManager addColorDidChangeObserver:label callback:^(id<WCDynamicColorProvider>  _Nonnull colorProvider, NSString * _Nonnull colorProviderName) {
                UIColor *color = [colorProvider colorWithProviderName:colorProviderName forKey:@"label_plain_string"];
                weak_label.textColor = color;
            }];
        }
         */
        
        _labelPlainString = label;
    }
    
    return _labelPlainString;
}

- (UILabel *)labelAttributedString {
    if (!_labelAttributedString) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelPlainString.frame) + 10, screenSize.width, 30)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = [self createAttributedString];
        
        [WCDynamicColorManager addColorDidChangeObserver:label callback:nil];
        
        _labelAttributedString = label;
    }
    
    return _labelAttributedString;
}

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelAttributedString.frame) + 10, screenSize.width, 30)];
        //textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.tintColor = [WCDynamicColorManager dynamicColorWithDefaultColor:[UIColor cyanColor] forKey:@"textField_tintColor_1" attachToObject:textField colorWillChangeBlock:nil];
        textField.layer.borderColor = [WCDynamicColorManager dynamicColorWithDefaultColor:[UIColor redColor] forKey:@"textField_borderColor_1" attachToObject:textField colorWillChangeBlock:nil].CGColor;
        
        __weak typeof(textField) weak_textField = textField;
        [WCDynamicColorManager addColorDidChangeObserver:textField callback:^(id<WCDynamicColorProvider>  _Nonnull colorProvider, NSString * _Nonnull colorProviderName) {
            UIColor *color = [colorProvider colorWithProviderName:colorProviderName forKey:@"textField_borderColor_1"];
            weak_textField.layer.borderColor = color.CGColor;
            weak_textField.tintColor = [colorProvider colorWithProviderName:colorProviderName forKey:@"textField_tintColor_1"];
        }];
        
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 2;
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark -

- (NSMutableAttributedString *)createAttributedString {
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:@""];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [WCDynamicColorManager dynamicColorWithDefaultColor:UICOLOR_RGBA(0x111F2C66) forKey:@"label_attributed_string_1" attachToObject:nil colorWillChangeBlock:nil];
    
    NSString *formatedValue = [NSString stringWithFormat:@"%@ ", @"[未读]"];
    [attrStringM appendAttributedString:ASTR2(formatedValue, attributes)];
    
    NSMutableDictionary *attributesM = [NSMutableDictionary dictionaryWithDictionary:attributes];
    attributesM[NSForegroundColorAttributeName] = [WCDynamicColorManager dynamicColorWithDefaultColor:UICOLOR_RGBA(0x0089FF) forKey:@"label_attributed_string_2" attachToObject:nil colorWillChangeBlock:nil];
    
    [attrStringM appendAttributedString:ASTR2(@"为什么面膜", attributesM)];
    
    return attrStringM;
}


#pragma mark - Action

- (void)nextItemClicked:(id)sender {
//    [self.navigationController pushViewController:[UseDynamicColorToGetViewController new] animated:YES];
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        [self.view endEditing:YES];
    }
}


#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.colorProviderList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    [[WCDynamicColorManager sharedManager] setCurrentColorProviderName:self.colorProviderList[index]];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.colorProviderList count];
}

@end
