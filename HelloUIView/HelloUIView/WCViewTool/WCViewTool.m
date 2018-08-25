//
//  WCViewTool.m
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

#define PauseOnThisLineWhenAddedExceptionBreakpoint(shouldPause) \
@try { \
    if (shouldPause) { \
        [NSException raise:@"Assert Exception" format:@""]; \
    } \
} \
@catch (NSException *exception) {}

@interface ViewObserver : NSObject
@property (nonatomic, weak) UIView *view;
@end

@implementation ViewObserver
- (instancetype)initWithView:(UIView *)view options:(NSKeyValueObservingOptions)options {
    self = [super init];
    if (self) {
        _view = view;
        // @see https://stackoverflow.com/questions/4874288/how-can-i-do-key-value-observing-and-get-a-kvo-callback-on-a-uiviews-frame
        [view addObserver:self forKeyPath:@"frame" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"bounds" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"transform" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"position" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"zPosition" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"anchorPoint" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"anchorPointZ" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"frame" options:options context:NULL];
        [view.layer addObserver:self forKeyPath:@"transform" options:options context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {    
    PauseOnThisLineWhenAddedExceptionBreakpoint(YES);
    
    NSLog(@"object: %@", object);
    NSLog(@"change: %@", change);
}

- (void)dealloc {
    [_view removeObserver:self forKeyPath:@"frame"];
    
    [_view.layer removeObserver:self forKeyPath:@"bounds"];
    [_view.layer removeObserver:self forKeyPath:@"transform"];
    [_view.layer removeObserver:self forKeyPath:@"position"];
    [_view.layer removeObserver:self forKeyPath:@"zPosition"];
    [_view.layer removeObserver:self forKeyPath:@"anchorPoint"];
    [_view.layer removeObserver:self forKeyPath:@"anchorPointZ"];
    [_view.layer removeObserver:self forKeyPath:@"frame"];
    [_view.layer removeObserver:self forKeyPath:@"transform"];
    NSLog(@"dealloc");
}

@end

@implementation WCViewTool

#pragma mark - Blurring

+ (void)blurWithView:(UIView *)view style:(UIBlurEffectStyle)style {
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = view.bounds;
    [view addSubview:visualEffectView];
}

#pragma mark - Debug

+ (void)registerGeometryChangedObserverForView:(UIView *)view {
    
    ViewObserver *observer = [[self observers] objectForKey:view];
    if (!observer) {
        ViewObserver *viewObserver = [[ViewObserver alloc] initWithView:view options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld];
        
        [[self observers] setObject:viewObserver forKey:view];
    }
}

+ (void)unregisterGeometryChangeObserverForView:(UIView *)view {
    ViewObserver *observer = [[self observers] objectForKey:view];
    if (observer) {
        [[self observers] removeObjectForKey:view];
    }
}

+ (NSMapTable *)observers {
    static NSMapTable *mapTable;
    if (!mapTable) {
        mapTable = [NSMapTable weakToStrongObjectsMapTable];
    }
    
    return mapTable;
}

@end
