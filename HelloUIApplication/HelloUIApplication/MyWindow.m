//
//  MyWindow.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/3/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "MyWindow.h"

@implementation MyWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"detected shake in custom UIWindow");
    }
}

@end
