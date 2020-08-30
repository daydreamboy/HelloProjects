//
//  WCViewTool.m
//  HelloWKWebView
//
//  Created by wesley_chen on 2020/8/30.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

@implementation WCViewTool

+ (BOOL)enumerateSubviewsInView:(UIView *)view enumerateIncludeView:(BOOL)enumerateIncludeView usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    
    if (![view isKindOfClass:[UIView class]] || !block) {
        return NO;
    }
    
    BOOL stop = NO;
    
    if (enumerateIncludeView) {
        block(view, &stop);
        if (stop) {
            return YES;
        }
    }
    
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [self traverseViewHierarchyWithView:subview usinglock:block stop:&stop];
        if (stop) {
            break;
        }
    }
    
    return YES;
}

#pragma mark ::

+ (void)traverseViewHierarchyWithView:(UIView *)view usinglock:(void (^)(UIView *subview, BOOL *stop))block stop:(BOOL *)stop {
    // not use `if (block)` to protect, because it maybe consumes more time when recursion
    block(view, stop);
    
    if (*stop) {
        return;
    }
    
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [self traverseViewHierarchyWithView:subview usinglock:block stop:stop];
        if (*stop) {
            break;
        }
    }
}

#pragma mark ::

@end
