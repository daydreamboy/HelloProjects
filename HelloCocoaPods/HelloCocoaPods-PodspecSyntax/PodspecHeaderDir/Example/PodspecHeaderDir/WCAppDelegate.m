//
//  WCAppDelegate.m
//  header_dir
//
//  Created by daydreamboy on 11/10/2017.
//  Copyright (c) 2017 daydreamboy. All rights reserved.
//

#import "WCAppDelegate.h"

// Note: find header by HEADER_SEARCH_PATHS = "${PODS_ROOT}/Headers/Public/PodspecHeaderDir"
#import <MyHeader/Manager.h>

// Note: find header by HEADER_SEARCH_PATHS = "${PODS_ROOT}/Headers/Public"
/*
#import <PodspecHeaderDir/MyHeader/Manager.h>
 */

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[Manager new] doSomething];
    return YES;
}
@end
