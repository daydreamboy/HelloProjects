//
//  DetectShakeMotionViewController.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/3/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "DetectShakeMotionViewController.h"
#import "MyWindow.h"

@interface DetectShakeView : UIView

@end

@implementation DetectShakeView

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"detected shake in custom UIView");
    }
    
    [super motionEnded:motion withEvent:event];
}

@end

@interface DetectShakeMotionViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) DetectShakeView *shakeView;
@end

@implementation DetectShakeMotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
    [self.view addSubview:self.shakeView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCShakeMotionNotification:) name:@"WCShakeMotionNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.shakeView becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"detected shake in UIViewController");
    }
    
    [super motionEnded:motion withEvent:event];
}

#pragma mark - Getter

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 10;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, paddingH, screenSize.width - 2 * paddingH, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField = textField;
    }
    
    return _textField;
}

- (DetectShakeView *)shakeView {
    if (!_shakeView) {
        DetectShakeView *view = [[DetectShakeView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        
        _shakeView = view;
    }
    
    return _shakeView;
}

#pragma mark - Action

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self.view) {
        MyWindow *window = [[MyWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
    }
}

#pragma mark - NSNotification

- (void)handleWCShakeMotionNotification:(NSNotification *)notification {
    NSLog(@"test");
}

@end
