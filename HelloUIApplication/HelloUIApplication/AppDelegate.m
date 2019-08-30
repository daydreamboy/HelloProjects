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
    
    const char *homeDir = getenv("HOME");
    
    if (homeDir)
        printf("Home directory is %s\n", homeDir);
    else
        printf("Couldn't figure it out.\n");
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    NSLog(@"desktopPath: %@", desktopPath);
    
    return YES;
}

@end
