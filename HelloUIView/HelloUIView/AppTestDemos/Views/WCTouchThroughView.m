//
//  WCTouchThroughView.m
//  HelloUIView
//
//  Created by wesley_chen on 05/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCTouchThroughView.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

@interface WCTouchThroughView ()
// @see https://stackoverflow.com/a/13351665
@property (nonatomic, strong) NSPointerArray *weakTouchableSubviews;
@property (nonatomic, strong) UIView *dummyBackgoundView;
@end

@implementation WCTouchThroughView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dummyBackgoundView = [[UIView alloc] initWithFrame:self.bounds];
        _touchThrough = YES;
        
        [self addSubview:_dummyBackgoundView];
    }
    return self;
}

// 
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//
//    BOOL isInside = [super pointInside:point withEvent:event];
//    NSLog(@"super, isInside: %@", STR_OF_BOOL(isInside));
//
//    if (CGRectContainsPoint(self.touchableRegion, point)) {
//        return YES;
//    }
//    return NO;
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.touchThrough) {
        UIView *targetSubview;
        
        if (self.weakTouchableSubviews.count) {
            NSArray *subviews = self.interceptedSubviews;
            for (UIView *subview in subviews) {
                if (subview.superview == self) {
                    CGPoint convertedPoint = [subview convertPoint:point fromView:self];
                    if ([subview pointInside:convertedPoint withEvent:event]) {
                        targetSubview = [subview hitTest:convertedPoint withEvent:event];
                        break;
                    }
                }
            }
        }
        
        if (targetSubview) {
            return targetSubview;
        }
        else {
            if (self.backgroundRegionShouldTouchThrough) {
                BOOL shouldTouchThrough = self.backgroundRegionShouldTouchThrough();
                // Note: should not call [super hitTest:point withEvent:event], this will let subview which not registered in interceptedSubviews to respond touch
                return shouldTouchThrough ? nil : self.dummyBackgoundView;
            }
            else {
                return nil;
            }
        }
    }
    else {
        return [super hitTest:point withEvent:event];
    }
}

- (void)setInterceptedSubviews:(NSArray<UIView *> *)interceptedViews {
//    _weakTouchableSubviews = [NSMutableArray arrayWithCapacity:interceptedViews.count];
    _weakTouchableSubviews = [NSPointerArray weakObjectsPointerArray];
    for (UIView *view in interceptedViews) {
        // @see https://stackoverflow.com/a/9336430
        [_weakTouchableSubviews addPointer:(__bridge void * _Nullable)(view)];
    }
}

- (NSArray<UIView *> *)interceptedSubviews {
    NSMutableArray *subviews = [NSMutableArray arrayWithCapacity:_weakTouchableSubviews.count];
    for (UIView *view in _weakTouchableSubviews) {
        if (view) {
            [subviews addObject:view];
        }
    }
    return subviews;
}

@end
