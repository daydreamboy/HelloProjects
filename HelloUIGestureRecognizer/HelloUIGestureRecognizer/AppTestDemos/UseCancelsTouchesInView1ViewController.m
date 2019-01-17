//
//  UseCancelsTouchesInView1ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/1/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseCancelsTouchesInView1ViewController.h"
#import "WCAlertTool.h"

@interface MyView : UIView

@end

@implementation MyView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end

@interface UseCancelsTouchesInView1ViewController ()
@property (nonatomic, strong) MyView *myView;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, strong) UISwitch *switchEnableUIControlEventTouchUpInside;
@property (nonatomic, strong) UITapGestureRecognizer *gestureTap;
@end

@implementation UseCancelsTouchesInView1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelTip];
    [self.view addSubview:self.switchEnableUIControlEventTouchUpInside];
    [self.view addSubview:self.myView];
    
    self.gestureTap.cancelsTouchesInView = self.switchEnableUIControlEventTouchUpInside.on;
}

#pragma mark - Getters

- (UILabel *)labelTip {
    if (!_labelTip) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 0)];
        label.text = @"Turn off the @cancelsTouchesInView for the MyView";
        label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        _labelTip = label;
    }
    
    return _labelTip;
}

- (UISwitch *)switchEnableUIControlEventTouchUpInside {
    if (!_switchEnableUIControlEventTouchUpInside) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UISwitch *switcher = [[UISwitch alloc] init];
        switcher.center = CGPointMake(screenSize.width / 2.0, CGRectGetMaxY(_labelTip.frame) + CGRectGetHeight(switcher.bounds) / 2.0);
        switcher.on = YES;
        [switcher addTarget:self action:@selector(switchEnableUIControlEventTouchUpInsideToggle:) forControlEvents:UIControlEventValueChanged];
        _switchEnableUIControlEventTouchUpInside = switcher;
    }
    
    return _switchEnableUIControlEventTouchUpInside;
}

- (MyView *)myView {
    if (!_myView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.backgroundColor = [UIColor greenColor];
        view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myViewTapped:)];
        [view addGestureRecognizer:tapGesture];
        _gestureTap = tapGesture;
        
        _myView = view;
    }
    
    return _myView;
}

#pragma mark - Actions

- (void)myViewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    NSString *msg = [NSString stringWithFormat:@"%@", tappedView];
    [WCAlertTool presentAlertWithTitle:@"view tapped" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)buttonClicked:(id)sender {
    NSString *msg = [NSString stringWithFormat:@"%@", sender];
    [WCAlertTool presentAlertWithTitle:@"button clicked" message:msg cancelButtonTitle:@"Ok" cancelButtonDidClickBlock:nil];
}

- (void)switchEnableUIControlEventTouchUpInsideToggle:(UISwitch *)switcher {
    switcher.on = !switcher.on;
    
    self.gestureTap.cancelsTouchesInView = self.switchEnableUIControlEventTouchUpInside.on;
}

@end
