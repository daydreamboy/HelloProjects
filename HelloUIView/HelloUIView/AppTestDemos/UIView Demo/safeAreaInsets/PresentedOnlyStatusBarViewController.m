//
//  PresentedOnlyStatusBarViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "PresentedOnlyStatusBarViewController.h"
#import "WCViewTool.h"

@interface PresentedOnlyStatusBarViewController ()
@property (nonatomic, strong) UILabel *childView;
@end

@implementation PresentedOnlyStatusBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"screen size: %@", NSStringFromCGSize(screenSize));
    
    self.view.backgroundColor = [UIColor colorWithRed:157 / 255.0 green:254 / 255.0 blue:157 / 255.0 alpha:1];;
    
    self.childView = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.childView.backgroundColor = [UIColor lightGrayColor];
    self.childView.userInteractionEnabled = YES;
    self.childView.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(childViewTapped:)];
    [self.childView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.childView];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.childView.safeAreaInsets));
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.childView.safeAreaInsets));
    
    self.childView.frame = [WCViewTool safeAreaFrameWithParentView:self.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.childView.safeAreaInsets));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.childView.safeAreaInsets));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"_cmd: %@, self.view: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.view.safeAreaInsets));
    NSLog(@"_cmd: %@, self.childView: %@", NSStringFromSelector(_cmd), NSStringFromUIEdgeInsets(self.childView.safeAreaInsets));
    
    self.childView.text = NSStringFromUIEdgeInsets(self.view.safeAreaInsets);
}

#pragma mark - Action

- (void)childViewTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
