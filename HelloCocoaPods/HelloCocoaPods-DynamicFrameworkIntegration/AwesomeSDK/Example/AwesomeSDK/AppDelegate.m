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
    [AwesomeSDKManager doSomething];
//    [NSClassFromString(@"AwesomeSDKManager") doSomething];
    
    return YES;
}

@end
