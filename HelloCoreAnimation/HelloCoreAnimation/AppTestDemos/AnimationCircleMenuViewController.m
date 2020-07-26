//
//  AnimationCircleMenuViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/7/25.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "AnimationCircleMenuViewController.h"
#import "WCCircularMenuView.h"
#import "WCCircularMenuController.h"

@interface AnimationCircleMenuViewController () <ALPHACircleMenuDelegate>
@property (nonatomic, strong) WCCircularMenuController *menuController;
@end

@implementation AnimationCircleMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.menuController = [WCCircularMenuController new];
    [self.menuController addCircleMenuToView:self.view atPoint:self.view.center];
}

@end
