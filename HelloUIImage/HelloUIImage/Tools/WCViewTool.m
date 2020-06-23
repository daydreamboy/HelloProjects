//
//  WCViewTool.m
//  HelloUIImage
//
//  Created by wesley_chen on 2018/11/14.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCViewTool

#pragma mark - Assistant Methods

#pragma mark > CGRect

+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect {
    if (size.width <= 0 || size.height <= 0 ||
        rect.size.width <= 0 || rect.size.height <= 0) {
        return CGRectZero;
    }
    
    CGPoint origin = rect.origin;
    CGFloat deltaX = (rect.size.width - size.width) / 2.0;
    CGFloat deltaY = (rect.size.height - size.height) / 2.0;
    
    origin.x += deltaX;
    origin.y += deltaY;
    
    CGRect centeredRect = CGRectMake(origin.x, origin.y, size.width, size.height);
    return centeredRect;
}

#pragma mark > CGSize

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToWidth:(CGFloat)fixedWidth {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedWidth <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByWidth = (fixedWidth / contentSize.width);
    return CGSizeMake(fixedWidth, contentSize.height * ratioByWidth);
}

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToHeight:(CGFloat)fixedHeight {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedHeight <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByHeight = (fixedHeight / contentSize.height);
    return CGSizeMake(contentSize.width * ratioByHeight, fixedHeight);
}


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
