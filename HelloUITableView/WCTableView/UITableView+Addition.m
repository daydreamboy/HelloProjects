//
//  UITableView+Addition.m
//  LotteryMate
//
//  Created by wesley chen on 15/6/13.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import "UITableView+Addition.h"
#import <objc/runtime.h>

const char * const RemoveRedudantSeparatosObjectTag = "RemoveRedudantSeparatosObjectTag";
const char * const EmptyViewObjectTag = "EmptyViewObjectTag";

@implementation UITableView (Addition)

@dynamic removeRedudantSeparators;
@dynamic emptyView;

- (void)setRemoveRedudantSeparators:(BOOL)removeRedudantSeparators {
    if (removeRedudantSeparators) {
        if (!self.tableFooterView) {
            self.tableFooterView = [UIView new];
        }
    }
    
    objc_setAssociatedObject(self, RemoveRedudantSeparatosObjectTag, @(removeRedudantSeparators), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)removeRedudantSeparators {
    NSNumber *boolObj = objc_getAssociatedObject(self, RemoveRedudantSeparatosObjectTag);
    return [boolObj boolValue];
}

- (void)setEmptyView:(UIView *)emptyView {
    
    if (emptyView) {
        
        UIView *previousEmptyView = objc_getAssociatedObject(self, EmptyViewObjectTag);
        if (previousEmptyView) {
            [previousEmptyView removeFromSuperview];
            previousEmptyView = nil;
        }
        
        CGPoint origin = emptyView.frame.origin;
        CGRect frame = emptyView.frame;
        
        if (CGPointEqualToPoint(origin, CGPointZero)) {
            frame.origin.x = (CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2.0;
            frame.origin.y = (CGRectGetHeight(self.bounds) - CGRectGetHeight(frame)) / 2.0;
            emptyView.frame = frame;
        }
        [self addSubview:emptyView];
    }
    else {
        UIView *previousEmptyView = objc_getAssociatedObject(self, EmptyViewObjectTag);
        [previousEmptyView removeFromSuperview];
        previousEmptyView = nil;
    }
    
    objc_setAssociatedObject(self, EmptyViewObjectTag, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, EmptyViewObjectTag);
}

- (NSIndexPath *)indexPathForRowContainsSubview:(UIView *)subview {
    
    UIView *tableView = subview.superview;
    while (tableView && tableView != self) {
        tableView = tableView.superview;
    }
    
    if (tableView == self) {
        CGPoint topLeftPointInTableView = [subview convertPoint:CGPointZero toView:self];
        NSIndexPath *indexPath = [self indexPathForRowAtPoint:topLeftPointInTableView];
        
        return indexPath;
    }
    else {
        NSLog(@"Wanring: subview <%@> is not a child view of tableview <%@>", subview, self);
        return nil;
    }
}

@end
