//
//  MyApplication.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "MyApplication.h"
#import "WCTouchWindow.h"

@implementation MyApplication

- (void)sendEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:WCTouchWindow_InterfaceEventNotification object:event];
    
    [super sendEvent:event];
}

@end
