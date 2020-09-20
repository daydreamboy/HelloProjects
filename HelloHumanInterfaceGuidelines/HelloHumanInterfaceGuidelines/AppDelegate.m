//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"

#import "RootViewController.h"

#import "WCTheme.h"
#import "AppFontProvider.h"

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
    [self setupTheme];
    
    return YES;
}

- (void)setupTheme {
    [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"default"];
    [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"small"];
    [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"medium"];
    [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"large"];

    [[WCDynamicValueManager sharedManager] registerDynamicValueProvider:[AppFontProvider new] forName:@"default"];
    [[WCDynamicValueManager sharedManager] registerDynamicValueProvider:[AppFontProvider new] forName:@"small"];
    [[WCDynamicValueManager sharedManager] registerDynamicValueProvider:[AppFontProvider new] forName:@"medium"];
    [[WCDynamicValueManager sharedManager] registerDynamicValueProvider:[AppFontProvider new] forName:@"large"];
}

@end
