//
//  WCApplicationTool.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2021/1/1.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCApplicationTool.h"

@implementation WCApplicationTool

+ (NSString *)stringFromUITouchPhase:(UITouchPhase)phase {
    switch (phase) {
        case UITouchPhaseBegan:
            return @"begin";
        case UITouchPhaseMoved:
            return @"moved";
        case UITouchPhaseStationary:
            return @"stationary";
        case UITouchPhaseEnded:
            return @"ended";
        case UITouchPhaseCancelled:
            return @"cancelled";
        case UITouchPhaseRegionEntered:
            return @"regionEntered";
        case UITouchPhaseRegionMoved:
            return @"regionMoved";
        case UITouchPhaseRegionExited:
            return @"regionExited";
        default:
            return @"unknown";
    }
}

@end
