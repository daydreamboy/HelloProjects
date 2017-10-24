//
//  main.m
//  HelloLoadAndInitializeMethods
//
//  Created by chenliang-xy on 15/3/25.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"



@implementation SuperClass : NSObject

+ (void)initialize {
    NSLog(@"initialize method");
}

@end

@implementation SubClass : SuperClass
@end

int main(int argc, char * argv[]) {
    @autoreleasepool {

        [SubClass class];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
