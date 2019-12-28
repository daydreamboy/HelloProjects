//
//  UIView+StatusBar.m
//  HelloCaptureUIView
//
//  Created by chenliang-xy on 15/3/13.
//  Copyright (c) 2015年 chenliang-xy. All rights reserved.
//

#import "UIView+StatusBar.h"
#import "WCRuntimeHelper.h"

static UIView *statusBarInstance = nil;

@implementation UIView (StatusBar)

+ (UIView *)statusBarInstance {
    return statusBarInstance;
}

#pragma mark - 

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class statusBarClass = NSClassFromString(@"UIStatusBar");
        [WCRuntimeHelper exchangeSelectorForClass:statusBarClass origin:@selector(setFrame:) substitute:@selector(setFrame_intercepted:)];
        [WCRuntimeHelper exchangeSelectorForClass:statusBarClass origin:NSSelectorFromString(@"dealloc") substitute:@selector(dealloc_intercepted)];
    });
}

- (void)setFrame_intercepted:(CGRect)frame {
    [self setFrame_intercepted:frame];
    statusBarInstance = self;
}

- (void)dealloc_intercepted {
    statusBarInstance = nil;
    [self dealloc_intercepted];
}

@end
