//
//  UseUIMenuControllerViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseUIMenuControllerViewController.h"
#import "WCResponderTool.h"
#import "HipsterLabel.h"

@interface UseUIMenuControllerViewController ()
@property (nonatomic, strong) HipsterLabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSTimer *timerCheckFirstResponder;
@end

@implementation UseUIMenuControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    if (@available(iOS 10.0, *)) {
        self.timerCheckFirstResponder = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            id currentResponder = [WCResponderTool currentFirstResponder];
            NSLog(@"currentResponder: %@", currentResponder);
            
            id currentResponder2 = [WCResponderTool findFirstResponder];
            NSLog(@"currentResponder2: %@", currentResponder2);
        }];
    }
    else {
        // Fallback on earlier versions
    }
}

- (void)dealloc {
    [_timerCheckFirstResponder invalidate];
    _timerCheckFirstResponder = nil;
}

#pragma mark - Getters

- (HipsterLabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        
        HipsterLabel *label = [[HipsterLabel alloc] initWithFrame:CGRectMake(paddingH, paddingH, screenSize.width - 2 * paddingH, 30)];
        label.text = @"This is a label with context menu";
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(labelLongPressed:)];
        [label addGestureRecognizer:longPressGesture];
        
        _label = label;
        
    }
    
    return _label;
}

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label.frame) + 10, screenSize.width - 2 * paddingH, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"Type here ...";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark - Actions

- (void)labelLongPressed:(UILongPressGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    UIView *targetSuperView = targetView.superview;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (targetView && targetSuperView) {
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            
            if (!menuController.menuVisible) {
                [menuController setTargetRect:targetView.frame inView:targetSuperView];
                
                UIMenuItem *menuItemCopy = [[UIMenuItem alloc] initWithTitle:@"CustomAction" action:@selector(customAction:)];
                menuController.menuItems = @[ menuItemCopy ];
                
                BOOL success = [targetView becomeFirstResponder];
                NSLog(@"becomeFirstResponder: %@", success ? @"YES" : @"NO");
                
                // WARNING: call this method must after some UIResponder object has called becomeFirstResponder, 
                // or the UIMenuController will NOT show
                [menuController setMenuVisible:YES animated:YES];
            }
        }
    }
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES];
}

@end
