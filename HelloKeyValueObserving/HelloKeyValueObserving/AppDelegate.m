//
//  AppDelegate.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
