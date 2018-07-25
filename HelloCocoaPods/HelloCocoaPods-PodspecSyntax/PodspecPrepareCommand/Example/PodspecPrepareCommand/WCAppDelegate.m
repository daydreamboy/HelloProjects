//
//  WCAppDelegate.m
//  PodspecPrepareCommand
//
//  Created by daydreamboy on 03/14/2018.
//  Copyright (c) 2018 daydreamboy. All rights reserved.
//

#import "WCAppDelegate.h"
#import <WCMacroKit/WCMacroKit.h>

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"red: %@", UICOLOR_RGB(0xFF0000));
    return YES;
}

@end
