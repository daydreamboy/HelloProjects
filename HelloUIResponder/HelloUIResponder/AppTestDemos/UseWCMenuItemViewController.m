//
//  UseWCMenuItemViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/7/1.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseWCMenuItemViewController.h"
#import "WCResponderTool.h"
#import "HipsterLabel.h"
#import "WCMenuController.h"

@interface UseWCMenuItemViewController ()
@property (nonatomic, strong) HipsterLabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSTimer *timerCheckFirstResponder;
@property (nonatomic, strong) NSArray<WCMenuItem *> *menuItems;
@end

@implementation UseWCMenuItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    if (@available(iOS 10.0, *)) {
//        self.timerCheckFirstResponder = [NSTimer scheduledTimerWithTimeInterval:1.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            id currentResponder = [WCResponderTool currentFirstResponder];
//            NSLog(@"currentResponder: %@", currentResponder);
//            
//            id currentResponder2 = [WCResponderTool findFirstResponder];
//            NSLog(@"currentResponder2: %@", currentResponder2);
//        }];
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
            WCMenuController *menuController = [WCMenuController sharedMenuController];
            
            if (!menuController.menuVisible) {
                [menuController setTargetRect:targetView.frame inView:targetSuperView];
                
                menuController.menuItems = self.menuItems;
                [WCMenuController registerMenuItemsWithTargetView:targetView menuItems:self.menuItems];
                
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

#pragma mark - Getters

- (NSArray<WCMenuItem *> *)menuItems {
    if (!_menuItems) {
        WCMenuItem *menuItemCopy = [[WCMenuItem alloc] initWithTitle:@"CustomCopy" block:^(WCMenuItem * _Nonnull menuItem) {
            NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
        }];
        
        WCMenuItem *menuItemEnable = [[WCMenuItem alloc] initWithTitle:@"Enable" block:^(WCMenuItem * _Nonnull menuItem) {
            NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
            menuItem.state = menuItem.state == WCMenuItemStateSelected ? WCMenuItemStateNormal : WCMenuItemStateSelected;
        }];
        [menuItemEnable setTitle:@"Disable" forState:WCMenuItemStateSelected];
        
        _menuItems = @[ menuItemCopy, menuItemEnable ];
    }
    
    return _menuItems;
}

@end
