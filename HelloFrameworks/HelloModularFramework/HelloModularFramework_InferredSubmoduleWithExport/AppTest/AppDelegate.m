//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"

@import HelloModularFramework_InferredSubmoduleWithExport.Derived;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Note: PublicClassA is not included by HelloModularFramework_InferredSubmoduleWithExport.Derived
//    [PublicClassA doSomething];
    [Base doSomething];
    [Derived doSomething];
    
    return YES;
}

@end
