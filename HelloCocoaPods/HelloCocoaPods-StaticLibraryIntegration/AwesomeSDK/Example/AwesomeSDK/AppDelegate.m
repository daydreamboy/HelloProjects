//
//  AppDelegate.m
//  AwesomeSDK
//
//  Created by daydreamboy on 11/07/2017.
//  Copyright (c) 2017 daydreamboy. All rights reserved.
//

#import "AppDelegate.h"
#import <AwesomeSDK/AwesomeSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *frameworkPath = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:@"AwesomeSDK.framework"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    NSError *error;
    [frameworkBundle loadAndReturnError:&error];
    if (error) {
        NSLog(@"load framwork failed: %@", error);
    }
//    [AwesomeSDKManager doSomething];
    [NSClassFromString(@"AwesomeSDKManager") doSomething];
    return YES;
}

@end
