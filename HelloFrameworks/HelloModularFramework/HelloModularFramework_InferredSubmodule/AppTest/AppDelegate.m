//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"

//@import HelloModularFramework_InferredSubmodule;
@import HelloModularFramework_InferredSubmodule.PublicClassA;
@import HelloModularFramework_InferredSubmodule.PublicClassB;
@import HelloModularFramework_InferredSubmodule.PublicClassC;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PublicClassA doSomething];
    [PublicClassB doSomething];
    [PublicClassC doSomething];
    
    return YES;
}

@end
