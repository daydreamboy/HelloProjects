//
//  WCTouchWindow.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/1/3.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCTouchWindow.h"
#import <objc/runtime.h>
#import "WCTouchFingerView.h"
#import "WCTouchFingerViewController.h"

NSString * const WCTouchWindow_InterfaceEventNotification = @"WCTouchWindow_InterfaceEventNotification";

static const void * kAssociatedObjectKeyFingerView = @"kAssociatedKeyFingerView";

@interface WCTouchWindow ()
@property (nonatomic, strong) UIView *touchingView;
@property (nonatomic, assign) BOOL notificationRegistered;
@end

@implementation WCTouchWindow

+ (instancetype)defaultTouchWindow {
    WCTouchWindow *touchWindow = [[WCTouchWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    touchWindow.rootViewController = [WCTouchFingerViewController new];
    touchWindow.userInteractionEnabled = NO;
    touchWindow.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:touchWindow selector:@selector(handleInterfaceEvent:) name:WCTouchWindow_InterfaceEventNotification object:nil];
    touchWindow.notificationRegistered = YES;
    
    return touchWindow;;
}

- (void)displayTouchIndicatorWithEvent:(UIEvent *)event {
    NSSet *touches = [event allTouches];
    
    for (UITouch *touch in touches) {
        if (touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded) {
            [self removeFingerViewForTouch:touch];
        }
        else {
            [self updateFingerViewForTouch:touch];
        }
    }
}

- (void)setShouldDisplayTouches:(BOOL)shouldDisplayTouches {
    _shouldDisplayTouches = shouldDisplayTouches;
    
    self.hidden = !_shouldDisplayTouches;
}

#pragma mark - NSNotification

- (void)handleInterfaceEvent:(NSNotification *)notification {
    if (self.shouldDisplayTouches && [notification.object isKindOfClass:[UIEvent class]]) {
        UIEvent *event = notification.object;
        
        if (event.type == UIEventTypeTouches) {
            [self displayTouchIndicatorWithEvent:event];
        }
    }
}

#pragma mark -

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Lets place this window above everything
        self.windowLevel = UIWindowLevelStatusBar + 10000.0;
        
        self.touchingView = [[UIView alloc] initWithFrame:frame];
        self.touchingView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
        
        _shouldDisplayTouches = YES;
        
        [self addSubview:self.touchingView];
    }
    
    return self;
}

- (void)dealloc {
    if (self.notificationRegistered) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)updateFingerViewForTouch:(UITouch *)touch {
    WCTouchFingerView *fingerView = objc_getAssociatedObject(touch, kAssociatedObjectKeyFingerView);
    
    if (!fingerView) {
        CGPoint point = [touch locationInView:self.touchingView];
        
        fingerView = [[WCTouchFingerView alloc] initWithPoint:point];
        
        objc_setAssociatedObject(touch, kAssociatedObjectKeyFingerView, fingerView, OBJC_ASSOCIATION_ASSIGN);
        
        [self.touchingView addSubview:fingerView];
    }
    
    [fingerView updateWithTouch:touch];
}

- (void)removeFingerViewForTouch:(UITouch *)touch {
    WCTouchFingerView * fingerView = objc_getAssociatedObject(touch, kAssociatedObjectKeyFingerView);
    
    if (fingerView) {
        objc_setAssociatedObject(touch, kAssociatedObjectKeyFingerView, nil, OBJC_ASSOCIATION_ASSIGN);
        
        [fingerView removeFromSuperview];
    }
}

@end
