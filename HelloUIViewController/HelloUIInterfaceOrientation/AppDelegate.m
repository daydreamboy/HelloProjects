//
//  AppDelegate.m
//  HelloUIInterfaceOrientation
//
//  Created by wesley_chen on 2021/6/29.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WCInterfaceOrientationTool.h"

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    // Note: the translucent value of UITabBar and UINavigationBar are YES by default, this is cause off-screen rendering,
    // so set it to NO
    // @see https://stackoverflow.com/questions/45368350/is-there-something-wrong-of-ios-simulators-color-offscreen-rendered-function
    self.navController.navigationBar.translucent = NO;
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    UIInterfaceOrientationMask mask = [WCInterfaceOrientationTool application:application supportedInterfaceOrientationsForWindow:window];

    NSLog(@"app delegate orientation: %@", WCNSStringFromUIInterfaceOrientationMask(mask));

    return mask;
}

@end
