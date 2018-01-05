//
//  OverlayView.m
//  HelloUIView
//
//  Created by wesley_chen on 05/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "OverlayView.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@implementation OverlayView
// @see https://stackoverflow.com/questions/3834301/ios-forward-all-touches-through-a-view
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"super, isInside: %@", STR_OF_BOOL(isInside));
    
    if (CGRectContainsPoint(self.touchableRegion, point)) {
        return YES;
    }
    return NO;
}

@end
