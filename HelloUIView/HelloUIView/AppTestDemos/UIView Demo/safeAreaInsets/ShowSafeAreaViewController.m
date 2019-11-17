//
//  ShowSafeAreaViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ShowSafeAreaViewController.h"
#import "WCViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface ShowSafeAreaViewController ()
@property (nonatomic, assign) CGFloat additionalInsetsValue;
@end

@implementation ShowSafeAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"screen size: %@", NSStringFromCGSize(screenSize));
    
    self.additionalInsetsValue = 0;
    self.view.backgroundColor = [UIColor colorWithRed:157 / 255.0 green:254 / 255.0 blue:157 / 255.0 alpha:1];
    
    self.childView = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.childView.backgroundColor = [UIColor lightGrayColor];
    self.childView.userInteractionEnabled = YES;
    self.childView.textAlignment = NSTextAlignmentCenter;
    self.childView.numberOfLines = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childViewTapped:)];
    [self.childView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(childViewPanned:)];
    [self.childView addGestureRecognizer:panGesture];
    
    [self.view addSubview:self.childView];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.childView]));
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.childView]));
    
    self.childView.frame = [WCViewTool safeAreaFrameWithParentView:self.view];
    self.childView.text = NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.childView]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.childView]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.view]));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets([WCViewTool safeAreaInsetsWithView:self.childView]));
}

#pragma mark - Action

- (void)childViewTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)childViewPanned:(id)sender {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIPanGestureRecognizer *recognizer = sender;
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    // Note: make a threshold to limit the maximum of self.additionalInsetsValue
    CGFloat threshold = screenSize.height / 6.0;
    
    // Note: divide by screenSize.height to be a smaller delta value to slow finger moving fast
    self.additionalInsetsValue += (translation.y / screenSize.height);
    if (self.additionalInsetsValue < 0) {
        self.additionalInsetsValue = 0;
    }
    else if (self.additionalInsetsValue >= threshold) {
        self.additionalInsetsValue = threshold;
    }
    
    UIEdgeInsets additionalInsets = UIEdgeInsetsMake(self.additionalInsetsValue, self.additionalInsetsValue, self.additionalInsetsValue, self.additionalInsetsValue);
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        self.additionalSafeAreaInsets = additionalInsets;
#pragma GCC diagnostic pop
    }
    
    // Note: to trigger viewWillLayoutSubviews and viewDidLayoutSubviews
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

@end
