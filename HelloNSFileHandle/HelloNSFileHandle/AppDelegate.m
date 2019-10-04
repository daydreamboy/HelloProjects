//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"

static NSFileHandle *sReadHandler;

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Note: global NSFileHandle will keep a file handle, comment the following lines
    // to see the alert info
    // ---begin comment
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        sReadHandler = [NSFileHandle fileHandleForReadingAtPath:path];
    });
    // ---end comment
    
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

@end
