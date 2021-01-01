//
//  MyApplication.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2021/1/1.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "MyApplication.h"
#import "WCApplicationTool.h"

@implementation MyApplication

- (void)sendEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        NSLog(@"touch event: %f, number: %ld, phase: %@", event.timestamp, (long)[event.allTouches count], [WCApplicationTool stringFromUITouchPhase:[event.allTouches anyObject].phase]);
    }
    else {
        NSLog(@"unknown event: %f", event.timestamp);
    }
    [super sendEvent:event];
}

@end
