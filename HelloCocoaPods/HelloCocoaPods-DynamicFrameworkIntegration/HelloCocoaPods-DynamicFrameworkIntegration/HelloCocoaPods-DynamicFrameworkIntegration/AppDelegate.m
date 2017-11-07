//
//  AppDelegate.m
//  HelloCocoaPods-DynamicFrameworkIntegration
//
//  Created by wesley_chen on 07/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"

#import <AwesomeSDK/AwesomeSDK.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AwesomeSDKManager doSomething];
    
    return YES;
}

@end
