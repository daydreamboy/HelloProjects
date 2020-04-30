//
//  WCGestureTool.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCGestureTool.h"
#import "WCMockGestureWrapper.h"
#import "WCMirroringTapGestureRecognizer.h"
#import "WCViewTool.h"
#import <objc/runtime.h>

@implementation WCGestureTool

#pragma mark - Mock Tap Gesture

static void * const kAssociatedKeyMockTapGesture = (void *)&kAssociatedKeyMockTapGesture;

+ (BOOL)triggerTapGestureWithGesture:(UITapGestureRecognizer *)tapGesture atTapPosition:(CGPoint)tapPosition {
    if (![tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    if (!tapGesture.view) {
        return NO;
    }
    
    WCMockTapGestureWrapper *mockGesture = objc_getAssociatedObject(tapGesture, kAssociatedKeyMockTapGesture);
    if (![mockGesture isKindOfClass:[WCMockTapGestureWrapper class]]) {
        mockGesture = [self createMockTapGestureWithGesture:tapGesture];
        if (!mockGesture) {
            return NO;
        }
    }
    
    return [mockGesture triggerTapsAtPosition:tapPosition];
}

#pragma mark ::

+ (WCMockTapGestureWrapper *)createMockTapGestureWithGesture:(UITapGestureRecognizer *)gesture {
    WCMockTapGestureWrapper *mockTapGesture = nil;
    
    NSArray *gestureRecognizerTargets = [gesture valueForKey:@"_targets"];
    for (id gestureRecognizerTarget in gestureRecognizerTargets) {
        id target = [gestureRecognizerTarget valueForKey:@"_target"];
        
        do {
            @try {
                target = [gestureRecognizerTarget valueForKey:@"target"];
                break;
            }
            @catch (NSException *exception) {}
            
            @try {
                target = [gestureRecognizerTarget performSelector:@selector(target)];
                break;
            }
            @catch (NSException *exception) {}
        } while (NO);
        
        if (!target) {
            continue;
        }
        
        SEL action = nil;
        @try {
            NSMethodSignature *methodSignature = [gestureRecognizerTarget methodSignatureForSelector:NSSelectorFromString(@"action")];
            NSInvocation *invoke = [NSInvocation invocationWithMethodSignature:methodSignature];
            invoke.selector = NSSelectorFromString(@"action");
            [invoke invokeWithTarget:gestureRecognizerTarget];
            [invoke getReturnValue:&action];
        }
        @catch (NSException *exception) {}
        
        if (!action) {
            continue;
        }
        
        if (!mockTapGesture) {
            mockTapGesture = [[WCMockTapGestureWrapper alloc] initWithGesture:gesture];
        }
        
        [mockTapGesture addTarget:target action:action];
    }
    
    return mockTapGesture;
}

#pragma mark ::

#pragma mark - Mirroring Tap Gesture

+ (nullable UITapGestureRecognizer *)createMirroringTapGestureWithGesture:(UITapGestureRecognizer *)gesture target:(id)target action:(SEL)action {
    if (![gesture isKindOfClass:[UITapGestureRecognizer class]] || !target || !action) {
        return nil;
    }
    
    WCMirroringTapGestureRecognizer *mirroredTapGesture = [[WCMirroringTapGestureRecognizer alloc] initWithTarget:target action:action mirroredTapGestureRecognizer:gesture];
    mirroredTapGesture.numberOfTapsRequired = gesture.numberOfTapsRequired;
    mirroredTapGesture.numberOfTouchesRequired = gesture.numberOfTouchesRequired;
    
    return mirroredTapGesture;
}

+ (BOOL)addMirroredTapGesturesWithView:(UIView *)view target:(id)target action:(SEL)action recursive:(BOOL)recursive {
    if (![view isKindOfClass:[UIView class]] || !target || !action) {
        return NO;
    }
    
    if (recursive) {
        [WCViewTool enumerateSubviewsInView:view enumerateIncludeView:YES usingBlock:^(UIView *subview, BOOL *stop) {
            NSArray *mirroredTapGestures = [self createMirroredTapGesturesWithView:subview target:target action:action];
            if (mirroredTapGestures) {
                for (UITapGestureRecognizer *mirroredTapGesture in mirroredTapGestures) {
                    [subview addGestureRecognizer:mirroredTapGesture];
                }
            }
        }];
        
        return YES;
    }
    else {
        NSArray *mirroredTapGestures = [self createMirroredTapGesturesWithView:view target:target action:action];
        if (mirroredTapGestures) {
            for (UITapGestureRecognizer *mirroredTapGesture in mirroredTapGestures) {
                [view addGestureRecognizer:mirroredTapGesture];
            }
            
            return YES;
        }
    }
    
    return NO;
}

#pragma mark ::

+ (nullable NSArray<UITapGestureRecognizer *> *)createMirroredTapGesturesWithView:(UIView *)view target:(id)target action:(SEL)action {
    if (![view isKindOfClass:[UIView class]] || !target || !action) {
        return nil;
    }
    
    NSMutableArray *mirroredTapGestures = [NSMutableArray arrayWithCapacity:view.gestureRecognizers.count];
    for (UITapGestureRecognizer *gesture in view.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer *mirroredTapGesture = [self createMirroringTapGestureWithGesture:gesture target:target action:action];
            if (mirroredTapGesture) {
                [mirroredTapGestures addObject:mirroredTapGesture];
            }
        }
    }
    
    return mirroredTapGestures.count ? mirroredTapGestures : @[];
}

#pragma mark ::

@end
