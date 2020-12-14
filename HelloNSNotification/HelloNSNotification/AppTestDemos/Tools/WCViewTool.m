//
//  WCViewTool.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/5/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCViewTool

+ (CGRect)paddedRectWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    if (insets.top < 0 || insets.left < 0 || insets.bottom < 0 || insets.right < 0) {
        return CGRectZero;
    }
    
    if (insets.top + insets.bottom >= frame.size.height) {
        return CGRectZero;
    }
    
    if (insets.left + insets.right >= frame.size.width) {
        return CGRectZero;
    }
    
    return CGRectMake(insets.left, insets.top, frame.size.width - insets.left - insets.right, frame.size.height - insets.top - insets.bottom);
}

#pragma mark > SafeArea

+ (UIEdgeInsets)safeAreaInsetsWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return UIEdgeInsetsZero;
    }
#ifdef __IPHONE_11_0
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return view.safeAreaInsets;
#pragma GCC diagnostic pop
    }
    else {
        return UIEdgeInsetsZero;
    }
#else
    return UIEdgeInsetsZero;
#endif
}

+ (CGRect)safeAreaFrameWithParentView:(UIView *)parentView {
    if (![parentView isKindOfClass:[UIView class]]) {
        return CGRectZero;
    }
#ifdef __IPHONE_11_0
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return [self paddedRectWithFrame:parentView.bounds insets:parentView.safeAreaInsets];
#pragma GCC diagnostic pop
    }
    else {
        return parentView.bounds;
    }
#else
    return parentView.bounds;
#endif
}

+ (CGRect)safeAreaLayoutFrameWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return CGRectZero;
    }
    
    if (!view.superview) {
        return view.bounds;
    }
    
    // Note: get safe area rect of the parent view
    CGRect safeAreaOfParentView = [WCViewTool safeAreaFrameWithParentView:view.superview];
    CGRect intersection = CGRectIntersection(safeAreaOfParentView, view.frame);
    
    if (!CGRectContainsRect(safeAreaOfParentView, view.frame) && !CGRectIsNull(intersection)) {
        CGRect newFrame = [view.superview convertRect:intersection toView:view];
        
        return newFrame;
    }
    else {
        return view.bounds;
    }
}

@end
