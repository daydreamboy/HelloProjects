//
//  ManuallySendUIEventViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2021/3/31.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "ManuallySendUIEventViewController.h"

@interface ManuallySendUIEventViewController ()
@property (nonatomic, strong) UIButton *buttonClick;
@end

@implementation ManuallySendUIEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonClick];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIEvent *event = [UIEvent new];
    //event.type = UIEventTypeTouches;
    
    [[UIApplication sharedApplication] sendAction:@selector(buttonClicked:) to:self from:self.buttonClick forEvent:event];
    
    [[UIApplication sharedApplication] sendAction:@selector(myCustomMethod:) to:nil from:self.view forEvent:nil];
}

#pragma mark -

- (void)myCustomMethod {
    NSLog(@"SwiftRocks!");
}

#pragma mark - Getter

- (UIButton *)buttonClick {
    if (!_buttonClick) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Click Me!" forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(screenSize.width / 2.0, (screenSize.height - 64) / 2.0);
        
        _buttonClick = button;
    }
    
    return _buttonClick;
}

#pragma mark - Action

- (void)buttonClicked:(id)sender {
    NSLog(@"button clicked");
}

@end
