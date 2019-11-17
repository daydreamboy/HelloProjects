//
//  WCScrollViewTool.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCScrollViewTool.h"

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCScrollViewTool

+ (BOOL)safeSetContentInsetAdjustmentBehaviorWithScrollView:(UIScrollView *)scrollView behavior:(WCScrollViewContentInsetAdjustmentBehavior)behavior {
    
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

    if (IOS11_OR_LATER) {
        scrollView.contentInsetAdjustmentBehavior = (UIScrollViewContentInsetAdjustmentBehavior)behavior;
        
        return YES;
    }

#pragma GCC diagnostic pop
    
    return NO;
}

+ (UIEdgeInsets)actualContentInsetsWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return UIEdgeInsetsZero;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

    if (IOS11_OR_LATER) {
        return scrollView.adjustedContentInset;
    }

#pragma GCC diagnostic pop
    
    return scrollView.contentInset;
}

@end
