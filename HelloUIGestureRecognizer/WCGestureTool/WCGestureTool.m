//
//  WCGestureTool.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2019/12/10.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCGestureTool.h"
#import "WCMockGestureWrapper.h"
#import <objc/runtime.h>

@implementation WCGestureTool

static void * const kAssociatedKeyMockTapGesture = (void *)&kAssociatedKeyMockTapGesture;

+ (BOOL)triggerTapGestureWithGesture:(UITapGestureRecognizer *)tapGesture atTapPosition:(CGPoint)tapPosition {
    if (![tapGesture isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    
    if (!tapGesture.view) {
        return NO;
    }
    
    WCMockTapGestureWrapper *mockGesture =  objc_getAssociatedObject(tapGesture, kAssociatedKeyMockTapGesture);
    if (![mockGesture isKindOfClass:[WCMockTapGestureWrapper class]]) {
        mockGesture = [self createMockTapGestureWithGesture:tapGesture];
        if (!mockGesture) {
            return NO;
        }
    }
    
    return [mockGesture triggerTapsAtPosition:tapPosition];
}

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

@end
