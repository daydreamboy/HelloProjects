//
//  WCViewTool.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

@implementation WCViewTool

+ (BOOL)makeViewFrameToFitAllSubviewsWithSuperView:(UIView *)superView {
    if (![superView isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    NSArray *subviews = [superView subviews];
    if (subviews.count == 0) {
        return NO;
    }
    
    // 1 - calculate size
    CGRect r = CGRectZero;
    for (UIView *v in subviews) {
        r = CGRectUnion(r, v.frame);
    }
    
    // 2 - move all subviews inside
    CGPoint fix = r.origin;
    for (UIView *v in subviews) {
        v.frame = CGRectOffset(v.frame, -fix.x, -fix.y);
    }
    
    // 3 - move frame to negate the previous movement
    CGRect newFrame = CGRectOffset(superView.frame, fix.x, fix.y);
    newFrame.size = r.size;
    
    superView.frame = newFrame;
    
    return YES;
}

@end
