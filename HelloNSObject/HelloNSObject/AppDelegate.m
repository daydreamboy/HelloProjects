//
//  AppDelegate.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 16/12/8.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WCHeapTool.h"

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
    
//    [WCHeapTool enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id  _Nonnull object, __unsafe_unretained Class  _Nonnull actualClass) {
//        NSLog(@"%p: %@", object, NSStringFromClass(actualClass));
//    }];
    
    return YES;
}

@end
