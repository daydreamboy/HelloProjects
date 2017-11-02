//
//  AppDelegate.m
//  AppTest
//
//  Created by wesley_chen on 25/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AppDelegate.h"

//#import <HelloModularFramework_Header/PublicClassA.h>
@import HelloModularFramework_Header;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [PublicClassA doSomething];
    
    return YES;
}

@end
