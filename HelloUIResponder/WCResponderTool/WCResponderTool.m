//
//  WCResponderTool.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCResponderTool.h"

static __weak id sCurrentFirstResponder;

@interface UIResponder (WCResponderTool)
@end

@implementation UIResponder (WCResponderTool)
- (void)WCResponderTool_findFirstResponder:(id)sender {
    sCurrentFirstResponder = self;
}
@end

@implementation WCResponderTool

+ (nullable id)currentFirstResponder {
    sCurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(WCResponderTool_findFirstResponder:) to:nil from:nil forEvent:nil];
    return sCurrentFirstResponder;
}

+ (nullable id)findFirstResponder {
    id currentFirstResponder = nil;
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    currentFirstResponder = [self findFirstResponderWithView:[UIApplication sharedApplication].keyWindow];
    if (currentFirstResponder) {
        return currentFirstResponder;
    }
    
    for (UIWindow *window in windows) {
        if (window != [UIApplication sharedApplication].keyWindow) {
            currentFirstResponder = [self findFirstResponderWithView:window];
            if (currentFirstResponder) {
                return currentFirstResponder;
            }
        }
    }
    
    return currentFirstResponder;
}

+ (nullable NSArray<UIResponder *> *)responderChainWithResponder:(UIResponder *)responder {
    if (![responder isKindOfClass:[UIResponder class]]) {
        return nil;
    }
    
    NSMutableArray<UIResponder *> *responders = [NSMutableArray array];
    id nextResponder = responder;
    do {
        [responders addObject:nextResponder];
        nextResponder = responder.nextResponder;
    }
    while ([nextResponder isKindOfClass:[UIResponder class]] && [responder respondsToSelector:@selector(nextResponder)]);
    
    return [responders copy];
}

#pragma mark ::

+ (id)findFirstResponderWithView:(UIView *)view {
    if (view.isFirstResponder) {
        return view;
    }
    
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        id responder = [self findFirstResponderWithView:subview];
        if (responder) return responder;
    }
    
    return nil;
}

#pragma mark ::

@end
