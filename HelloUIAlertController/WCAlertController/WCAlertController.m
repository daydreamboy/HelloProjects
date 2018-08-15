//
//  WCAlertController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2018/8/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAlertController.h"

@interface WCAlertController ()
@property (nonatomic, strong) UIWindow *alertWindow;
@end

@implementation WCAlertController

#pragma mark - Public Methods

- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertWindow.rootViewController = [[UIViewController alloc] init];
    
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    // Applications that does not load with UIMainStoryboardFile might not have a window property:
    if ([delegate respondsToSelector:@selector(window)]) {
        // we inherit the main window's tintColor
        self.alertWindow.tintColor = delegate.window.tintColor;
    }
    
    // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
    UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
    self.alertWindow.windowLevel = topWindow.windowLevel + 1;
    
    [self.alertWindow makeKeyAndVisible];
    [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

#pragma mark -

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // precaution to insure window gets destroyed
    self.alertWindow.hidden = YES;
    self.alertWindow = nil;
}

- (void)dealloc {
    NSLog(@"dealloc: %p", self);
}

@end
