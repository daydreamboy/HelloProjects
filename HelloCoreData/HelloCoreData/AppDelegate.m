//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "FPSLabel.h"

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
    
    FPSLabel *fpsLabel = [FPSLabel new];
    [self.window addSubview:fpsLabel];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    fpsLabel.center = CGPointMake(60, screenSize.height - 40);
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"applicationDidReceiveMemoryWarning");
}

@end
