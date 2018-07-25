//
//  WCAppDelegate.m
//  PodspecHeaderMappingsDir
//
//  Created by daydreamboy on 07/25/2018.
//  Copyright (c) 2018 daydreamboy. All rights reserved.
//

#import "WCAppDelegate.h"

// Note: mapping Pods/Headers/Public/PodspecHeaderMappingsDir to PodspecHeaderMappingsDir/include,
// and reserve the structure of the include folder

// WARNING: only works with disable use_frameworks!
#import <system/SystemManager.h>
#import <utility/UtilityManager.h>

@implementation WCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", [SystemManager new]);
    NSLog(@"%@", [UtilityManager new]);
    
    return YES;
}

@end
