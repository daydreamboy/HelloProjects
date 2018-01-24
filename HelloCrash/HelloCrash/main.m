//
//  main.m
//  HelloCrash
//
//  Created by wesley_chen on 22/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WCUncaughtExceptionTool.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        [WCUncaughtExceptionTool installUncaughtExceptionHandler];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
    // Note: deprecate this way
    /*
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
    }
     */
}
