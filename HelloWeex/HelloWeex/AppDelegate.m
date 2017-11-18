//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AppDelegate.h"
#import <WeexSDK/WeexSDK.h>

#import "RootViewController.h"
#import "WeexImageDownloader.h"

@interface AppDelegate ()
@property (nonatomic, strong) RootViewController *rootViewController;
@property (nonatomic, strong) UINavigationController *navController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWeex];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.rootViewController = [RootViewController new];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupWeex {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //business configuration
        [WXAppConfiguration setAppGroup:@"AliApp"];
        [WXAppConfiguration setAppName:@"WeexDemo"];
        [WXAppConfiguration setAppVersion:@"1.0.0"];
        
        //init sdk environment
        [WXSDKEngine initSDKEnvironment];
        
        [WXSDKEngine registerHandler:[WeexImageDownloader new] withProtocol:@protocol(WXImgLoaderProtocol)];
        
        //set the log level
        [WXLog setLogLevel:WXLogLevelAll];
    });
}

@end
