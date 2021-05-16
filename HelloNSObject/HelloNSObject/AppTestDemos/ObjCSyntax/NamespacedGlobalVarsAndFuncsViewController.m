//
//  NamespacedGlobalVarsAndFuncsViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/4/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NamespacedGlobalVarsAndFuncsViewController.h"
#import "NamespacedDefines.h"

@interface NamespacedGlobalVarsAndFuncsViewController ()

@end

@implementation NamespacedGlobalVarsAndFuncsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMANotifyingArrayNotificationsDidAddObject:) name:MANotifyingArrayNotifications.didAddObject object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWCNotifyingArrayNotificationsDidRemoveObject:) name:WCNotifyingArrayNotifications.didRemoveObject object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MANotifyingArrayNotifications.didAddObject object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCNotifyingArrayNotifications.didRemoveObject object:nil];
}

#pragma mark - NSNotifications

- (void)handleMANotifyingArrayNotificationsDidAddObject:(NSNotification *)notification {
    NSLog(@"handle notifications");
    
    CGPoint topRight = MARectUtils.topRight(self.view.frame);
    NSLog(@"%@", NSStringFromCGPoint(topRight));
}

- (void)handleWCNotifyingArrayNotificationsDidRemoveObject:(NSNotification *)notification {
    NSLog(@"handle notifications2");
    
    CGPoint topRight = WCRectTool.topRight(self.view.frame);
    NSLog(@"%@", NSStringFromCGPoint(topRight));
}

@end
