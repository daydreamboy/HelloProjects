//
//  SystemSettingBoldTextViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2021/2/24.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "SystemSettingBoldTextViewController.h"

@end

@interface SystemSettingBoldTextViewController ()
@property (nonatomic, assign) BOOL systemBoldTextEnabled;
@property (nonatomic, strong) UILabel *labelSystemBoldTextEnabled;
@property (nonatomic, strong) UILabel *labelText;
@end

@implementation SystemSettingBoldTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelSystemBoldTextEnabled];
    [self.view addSubview:self.labelText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIAccessibilityBoldTextStatusDidChangeNotification:) name:UIAccessibilityBoldTextStatusDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _systemBoldTextEnabled = UIAccessibilityIsBoldTextEnabled();
    self.labelSystemBoldTextEnabled.text = [NSString stringWithFormat:@"bold text enabled: %@", _systemBoldTextEnabled ? @"YES": @"NO"];
}

#pragma mark - Getter

- (UILabel *)labelSystemBoldTextEnabled {
    if (!_labelSystemBoldTextEnabled) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat startY = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"ArialMT" size:14];
        label.textColor = [UIColor blackColor];
        
        _labelSystemBoldTextEnabled = label;
    }
    
    return _labelSystemBoldTextEnabled;
}

- (UILabel *)labelText {
    if (!_labelText) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelSystemBoldTextEnabled.frame) + 10, screenSize.width, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor blackColor];
        label.text = @"Hello, world! 你好，世界！";
        
        _labelText = label;
    }
    
    return _labelText;
}

#pragma mark - NSNotification

- (void)handleUIAccessibilityBoldTextStatusDidChangeNotification:(NSNotification *)notification {
    _systemBoldTextEnabled = UIAccessibilityIsBoldTextEnabled();
    self.labelSystemBoldTextEnabled.text = [NSString stringWithFormat:@"bold text enabled: %@", _systemBoldTextEnabled ? @"YES": @"NO"];
}

@end
