//
//  MyApplication.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "MyApplication.h"
#import "WCTouchIndicatorWindow.h"

@implementation MyApplication

- (void)sendEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:WCTouchWindow_InterfaceEventNotification object:event];
    
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        
        NSNumber *shakeState;
        @try {
            if ([event isKindOfClass:NSClassFromString(@"UIMotionEvent")]) {
                shakeState = [event valueForKey:@"shakeState"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            if (shakeState == nil || shakeState.intValue > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WCShakeMotionNotification" object:event];
            }
        }
        
        NSLog(@"detected shake in UIApplication");
    }
    
    [super sendEvent:event];
}

@end
