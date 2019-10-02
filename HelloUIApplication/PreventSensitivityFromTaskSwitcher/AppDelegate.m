//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
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

// @see https://medium.com/livefront/cover-up-your-users-sensitive-data-it-s-private-309c0173dffd
// @see https://developer.apple.com/library/archive/qa/qa1838/_index.html
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Your application can present a full screen modal view controller to
    // cover its contents when it moves into the background. If your
    // application requires a password unlock when it retuns to the
    // foreground, present your lock screen or authentication view controller here.
 
    UIViewController *blankViewController = [UIViewController new];
    blankViewController.view.backgroundColor = [UIColor blackColor];
 
    // Pass NO for the animated parameter. Any animation will not complete
    // before the snapshot is taken.
    [self.window.rootViewController presentViewController:blankViewController animated:NO completion:NULL];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // This should be omitted if your application presented a lock screen
    // in -applicationDidEnterBackground:
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
}

@end
