//
//  main.m
//  OrderOfCallInitializeMethodInNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SuperClass : NSObject
@end
@implementation SuperClass

+ (void)initialize {
    NSLog(@"%@: initialize method", NSStringFromClass(self));
}

@end

@interface SubClass : SuperClass
@end
@implementation SubClass
@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [SubClass class];
        [SubClass class]; // Note: not call initialize again
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
