//
//  WCViewTool.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/4/30.
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

+ (UIView *)clippingParentViewWithView:(UIView *)view {
    UIView *viewToCheck = [view superview];
    if (viewToCheck) {
        if (viewToCheck.clipsToBounds) {
            return viewToCheck;
        }
        else {
            return [self clippingParentViewWithView:viewToCheck];
        }
    }
    else {
        return view;
    }
}

@end
