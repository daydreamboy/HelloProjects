//
//  AppDelegate.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 14-11-27.
//  Copyright (c) 2014年 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "WCEmoticonDataSource.h"

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
    
    [self setupEmoticonDataSource];
    						
    return YES;
}

- (void)setupEmoticonDataSource {
    NSTimeInterval startTime = CACurrentMediaTime();
    
    NSLog(@"start load emoticon image: %f", startTime);
    [[WCEmoticonDataSource sharedInstance] preloadEmoticonImageWithCompletion:^{
        NSTimeInterval endTime = CACurrentMediaTime();
        NSLog(@"end load emoticon image: %f, consume time: %f", endTime, endTime - startTime);
    }];
    
    NSLog(@"start load emoticon order:: %f", startTime);
    [[WCEmoticonDataSource sharedInstance] preloadEmoticonOrderWithCompletion:^{
        NSTimeInterval endTime = CACurrentMediaTime();
        NSLog(@"end load emoticon order: %f, consume time: %f", endTime, endTime - startTime);
    }];
}

@end
