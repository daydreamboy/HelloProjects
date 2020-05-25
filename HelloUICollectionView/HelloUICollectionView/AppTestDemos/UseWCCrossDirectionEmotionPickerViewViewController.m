//
//  UseWCCrossDirectionEmotionPickerViewViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseWCCrossDirectionEmotionPickerViewViewController.h"
#import "WCCrossDirectionEmotionPickerView.h"
#import "WCViewTool.h"
#import "WCPopoverView.h"

@interface UseWCCrossDirectionEmotionPickerViewViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) WCCrossDirectionEmotionPickerView *emotionPickerView;
@property (nonatomic, strong) UIButton *buttonShowPopoverView;
@property (nonatomic, strong) WCPopoverView *popoverView;
@end

@implementation UseWCCrossDirectionEmotionPickerViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.buttonShowPopoverView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, CGRectGetHeight(self.emotionPickerView.bounds) + [WCViewTool safeAreaInsetsWithView:self.view].bottom)];
    [view addSubview:self.emotionPickerView];
    
    self.textField.inputView = view;
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, 100, screenSize.width - 2 * paddingH, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"Type here...";
        
        _textField = textField;
    }
    
    return _textField;
}

- (WCCrossDirectionEmotionPickerView *)emotionPickerView {
    if (!_emotionPickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _emotionPickerView = [[WCCrossDirectionEmotionPickerView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 216)];
    }
    
    return _emotionPickerView;
}

- (UIButton *)buttonShowPopoverView {
    if (!_buttonShowPopoverView) {
        CGFloat paddingH = 20;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor redColor].CGColor;
        button.layer.borderWidth = 1;
        [button setTitle:@"Show Popover" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonShowPopoverViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(paddingH, CGRectGetMaxY(_textField.frame) + paddingH, button.bounds.size.width, button.bounds.size.height);
        
        _buttonShowPopoverView = button;
    }
    
    return _buttonShowPopoverView;
}

#pragma mark - Action

- (void)buttonShowPopoverViewClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor greenColor];
    label.text = @"点击试试";
    
    [label sizeToFit];
//    label.layer.cornerRadius = CGRectGetHeight(label.bounds) / 2.0;
//    label.layer.masksToBounds = YES;
    
    WCPopoverViewDescriptor *descriptor = [WCPopoverViewDescriptor new];
    descriptor.autoDismissAfterSeconds = 0;
    descriptor.boxPadding = 10;
    descriptor.showDuration = 0.15;
    descriptor.dismissDuration = 0.1;
    descriptor.autoDismissWhenTapOutside = YES;
    descriptor.boxCornerRadius = 20;
    descriptor.borderWidth = 3;
    descriptor.borderColor = [UIColor redColor];
//    descriptor.boxGradientLocations = nil;
//    descriptor.boxGradientColors = nil;
//    descriptor.boxShadowBlurColor = [UIColor redColor];
//    descriptor.boxShadowBlurRadius = 10;
    
    CGPoint topMiddlePoint = CGPointMake(CGRectGetMidX(button.bounds), 0);
    CGPoint locationInWindow = [button convertPoint:topMiddlePoint toView:button.window];
    self.popoverView = [WCPopoverView showPopoverViewAtPoint:locationInWindow inView:button.window contentView:label descriptor:descriptor];
}

@end
