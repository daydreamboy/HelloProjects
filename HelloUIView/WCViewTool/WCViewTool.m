//
//  WCViewTool.m
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>
#import "WCKVOTool.h"

#define PauseOnThisLineWhenAddedExceptionBreakpoint(shouldPause) \
@try { \
    if (shouldPause) { \
        [NSException raise:@"Assert Exception" format:@""]; \
    } \
} \
@catch (NSException *exception) {}

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


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

#pragma mark - Hierarchy

+ (BOOL)enumerateSubviewsInView:(UIView *)view enumerateIncludeView:(BOOL)enumerateIncludeView usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    
    if (![view isKindOfClass:[UIView class]] || !block) {
        return NO;
    }
    
    BOOL stop = NO;
    
    if (enumerateIncludeView) {
        block(view, &stop);
        if (stop) {
            return YES;
        }
    }
    
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [self traverseViewHierarchyWithView:subview usinglock:block stop:&stop];
        if (stop) {
            break;
        }
    }
    
    return YES;
}

#pragma mark ::

+ (void)traverseViewHierarchyWithView:(UIView *)view usinglock:(void (^)(UIView *subview, BOOL *stop))block stop:(BOOL *)stop {
    // not use `if (block)` to protect, because it maybe consumes more time when recursion
    block(view, stop);
    
    if (*stop) {
        return;
    }
    
    NSArray *subviews = [view subviews];
    for (UIView *subview in subviews) {
        [self traverseViewHierarchyWithView:subview usinglock:block stop:stop];
        if (*stop) {
            break;
        }
    }
}

#pragma mark ::

+ (nullable UIView *)checkAncestralViewWithView:(UIView *)view ancestralViewIsKindOfClass:(Class)cls {
    if (![view isKindOfClass:[UIView class]] || cls == nil) {
        return nil;
    }
    
    UIView *ancestralView = nil;
    if ([view isKindOfClass:cls]) {
        ancestralView = view;
    }
    else {
        UIView *aView = view.superview;
        while (aView && ![aView isKindOfClass:cls]) {
            aView = aView.superview;
        }
        if ([aView isKindOfClass:cls]) {
            ancestralView = aView;
        }
    }
    
    return ancestralView;
}

+ (UIViewController *)holdingViewControllerWithView:(UIView *)view {
    UIResponder *responder = view;
    
    while ([responder isKindOfClass:[UIView class]]) {
        // @note about nextResponder from apple doc:
        // UIView implements this method by returning the UIViewController object that manages it (if it has one) or its superview (if it doesn’t);
        // UIViewController implements the method by returning its view’s superview;
        // UIWindow returns the application object;
        // UIApplication returns nil.
        responder = [responder nextResponder];
    }
    
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    else {
        return nil;
    }
}

+ (void)hierarchalDescriptionWithView:(UIView *)view {
    // Note: recursiveDescription is a private method, disabled in release mode
#if DEBUG
    
    if ([view isKindOfClass:[UIView class]]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSLog(@"hierarchalDescription:\n\n%@", [view performSelector:NSSelectorFromString(@"recursiveDescription")]);
#pragma GCC diagnostic pop
    }
    
#endif
}

#pragma mark - Frame Adjustment

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

+ (BOOL)makeSubviewsIntoGroup:(NSArray *)subviews centeredAtPoint:(CGPoint)centerPoint groupViewsRect:(inout nullable CGRect *)groupViewsRect {
    if (![subviews isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if (subviews.count == 0) {
        return NO;
    }
    
    // 1 - calculate original group rect
    CGRect originalGroupRect = CGRectZero;
    for (UIView *v in subviews) {
        originalGroupRect = CGRectUnion(originalGroupRect, v.frame);
    }
    
    // 2 - get the movement according to the center point
    CGVector movement = CGVectorMake(centerPoint.x - CGRectGetMidX(originalGroupRect), centerPoint.y - CGRectGetMidY(originalGroupRect));
    
    // 3 - adjust group rect
    CGRect newGroupRect = CGRectOffset(originalGroupRect, movement.dx, movement.dy);
    if (groupViewsRect) {
        *groupViewsRect = newGroupRect;
    }
    
    // 4 - adjust subviews
    for (UIView *v in subviews) {
        v.frame = CGRectOffset(v.frame, movement.dx, movement.dy);
    }
    
    return YES;
}

+ (BOOL)changeFrameWithView:(UIView *)view newX:(CGFloat)newX newY:(CGFloat)newY newWidth:(CGFloat)newWidth newHeight:(CGFloat)newHeight {
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    view.frame = [self changeFrame:view.frame newX:newX newY:newY newWidth:newWidth newHeight:newHeight];
    
    return YES;
}

+ (BOOL)changeCenterWithView:(UIView *)view newCX:(CGFloat)newCX newCY:(CGFloat)newCY {
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    view.center = [self changeCenter:view.center newCX:newCX newCY:newCY];
    
    return YES;
}

#pragma mark - Visibility

+ (BOOL)checkViewVisibleToUserWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    if (view.window == nil) {
        return NO;
    }
    
    if (view.hidden == YES  || view.alpha < 0.01) {
        return NO;
    }
    
    if (view.bounds.size.width <= 0 || view.bounds.size.height <= 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Add Layers

static void * const kAssociatedKeyaddGradientLayerWithView = (void *)&kAssociatedKeyaddGradientLayerWithView;

+ (BOOL)addGradientLayerWithView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint addToTop:(BOOL)addToTop observeViewBoundsChange:(BOOL)observeViewBoundsChange {
    if (![view isKindOfClass:[UIView class]] || ![startColor isKindOfClass:[UIColor class]] || ![endColor isKindOfClass:[UIColor class]]) {
        return NO;
    }
    
    BOOL found = NO;
    for (CALayer *layer in [view.layer sublayers]) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:[NSString stringWithFormat:@"gradientLayer_%p", layer]]) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.name = [NSString stringWithFormat:@"gradientLayer_%p", gradientLayer];
        gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
        gradientLayer.locations = @[ @0.0, @1.0 ];
        gradientLayer.startPoint = startPoint;
        gradientLayer.endPoint = endPoint;
        gradientLayer.masksToBounds = YES;
        gradientLayer.frame = view.layer.bounds;
        
        if (observeViewBoundsChange) {
            __weak typeof(gradientLayer) weak_gradientLayer = gradientLayer;
            [WCKVOTool observeKVOEventWithObject:view.layer keyPath:@"bounds" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew associatedKey:kAssociatedKeyaddGradientLayerWithView eventCallback:^(CALayer * _Nonnull layer, WCKVOObserver *observer) {
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                weak_gradientLayer.frame = layer.bounds;
                [CATransaction commit];
            }];
        }
        
        if (addToTop) {
            [view.layer addSublayer:gradientLayer];
        }
        else {
            [view.layer insertSublayer:gradientLayer atIndex:0];
        }
    }
    
    return YES;
}

+ (BOOL)removeGradientLayerWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return NO;
    }
    
    CAGradientLayer *gradientLayer;
    for (CALayer *layer in [view.layer sublayers]) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:[NSString stringWithFormat:@"gradientLayer_%p", layer]]) {
            gradientLayer = (CAGradientLayer *)layer;
            break;
        }
    }
    
    if (!gradientLayer) {
        [gradientLayer removeFromSuperlayer];
        return YES;
    }
    
    return NO;
}

#pragma mark - View State

static void * const kAssociatedKeySubviewStates = (void *)&kAssociatedKeySubviewStates;

+ (nullable NSDictionary<NSString *, NSDictionary *> *)storeAllSubviewStatesWithView:(UIView *)view properties:(NSArray<NSString *> *)properties {
    if (![view isKindOfClass:[UIView class]] || ![properties isKindOfClass:[NSArray class]] || properties.count == 0) {
        return nil;
    }
    
    id associatedObject = objc_getAssociatedObject(view, kAssociatedKeySubviewStates);
    
    if (associatedObject && ![associatedObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (associatedObject && [associatedObject isKindOfClass:[NSDictionary class]]) {
        return associatedObject;
    }
    
    NSMutableDictionary *recordMap = [NSMutableDictionary dictionary];
    
    __block BOOL stopFlag = NO;
    [self enumerateSubviewsInView:view enumerateIncludeView:NO usingBlock:^(UIView * _Nonnull subview, BOOL * _Nonnull stop) {
        @try {
            NSMutableDictionary *stateM = [NSMutableDictionary dictionary];
            for (NSString *property in properties) {
                id value = nil;
                if ([property rangeOfString:@"."].location != NSNotFound) {
                    value = [subview valueForKeyPath:property];
                }
                else {
                    value = [subview valueForKey:property];
                }
                
                if (value) {
                    stateM[property] = value;
                }
            }
            
            recordMap[[NSString stringWithFormat:@"%p", subview]] = stateM;
        }
        @catch (NSException *exception) {
            *stop = YES;
            stopFlag = YES;
        }
    }];
    
    if (stopFlag) {
        return nil;
    }
    
    objc_setAssociatedObject(view, kAssociatedKeySubviewStates, recordMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return recordMap;
}

+ (NSDictionary<NSString *, NSDictionary *> *)restoreAllSubviewStatesWithView:(UIView *)view properties:(nullable NSArray<NSString *> *)properties {
    if (![view isKindOfClass:[UIView class]] || (properties && ![properties isKindOfClass:[NSArray class]])) {
        return nil;
    }
    
    id associatedObject = objc_getAssociatedObject(view, kAssociatedKeySubviewStates);
    
    if (!associatedObject || (associatedObject && ![associatedObject isKindOfClass:[NSDictionary class]])) {
        return nil;
    }
    
    NSMutableDictionary *recordMap = associatedObject;
    
    __block BOOL stopFlag = NO;
    [self enumerateSubviewsInView:view enumerateIncludeView:NO usingBlock:^(UIView * _Nonnull subview, BOOL * _Nonnull stop) {
        NSDictionary *stateM = recordMap[[NSString stringWithFormat:@"%p", subview]];
        if ([stateM isKindOfClass:[NSDictionary class]]) {
            NSArray *propertiesToRestore;
            if (properties.count == 0) {
                propertiesToRestore = [stateM allKeys];
            }
            else {
                propertiesToRestore = properties;
            }
            
            @try {
                for (NSString *property in propertiesToRestore) {
                    id value = stateM[property];
                    if (value) {
                        if ([property rangeOfString:@"."].location != NSNotFound) {
                            [subview setValue:value forKeyPath:property];
                        }
                        else {
                            [subview setValue:value forKey:property];
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                *stop = YES;
                stopFlag = YES;
            }
        }
    }];
    
    if (stopFlag) {
        return nil;
    }
    
    return recordMap;
}

#pragma mark - View Snapshot

+ (nullable UIImage *)snapshotWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIImage *image = nil;
    CGSize outputSize = view.bounds.size;

    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            // Note: set afterScreenUpdates force to YES, because the view maybe not render on screen,
            // on this situation, drawViewHierarchyInRect can't capture the view snapshot
            // @see https://stackoverflow.com/questions/27410991/how-can-i-take-a-snapshot-of-a-uiview-that-isnt-rendered
            [view drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:YES];
        }
        else {
            [view.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (nullable UIImage *)snapshotWithWindow:(UIWindow *)window includeStatusBar:(BOOL)includeStatusBar afterScreenUpdates:(BOOL)afterScreenUpdates {
    if (![window isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = includeStatusBar ? [self getStatusBarIfNeeded] : nil;
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:afterScreenUpdates];
        }
        else {
            [window.layer renderInContext:context];
        }
        
        if (statusBar) {
            [statusBar.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (nullable UIImage *)snapshotWithScrollView:(UIScrollView *)scrollView shouldConsiderContent:(BOOL)shouldConsiderContent {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return nil;
    }
    
	UIImage *image = nil;
    CGSize outputSize = shouldConsiderContent ? scrollView.contentSize : scrollView.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        if (shouldConsiderContent) {
            // Saved
            CGPoint savedContentOffset = scrollView.contentOffset;
            CGRect savedFrame = scrollView.frame;
            BOOL savedShowsHorizontalScrollIndicator = scrollView.showsHorizontalScrollIndicator;
            BOOL savedShowsVerticalScrollIndicator = scrollView.showsVerticalScrollIndicator;
            BOOL savedUserInteractionEnabled = scrollView.userInteractionEnabled;
            
            // Adjust frame, contentOffset, hide indicators, and disable user interaction
            scrollView.contentOffset = CGPointZero;
            scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.userInteractionEnabled = NO;
            
            // Note: not use drawViewHierarchyInRect:afterScreenUpdates: method, because
            // it only draws visible part of UIScrollView even after adjust its size, contentOffset and so on.
            
            [scrollView.layer renderInContext:context];
        
            // Restore
            scrollView.contentOffset = savedContentOffset;
            scrollView.frame = savedFrame;
            scrollView.showsHorizontalScrollIndicator = savedShowsHorizontalScrollIndicator;
            scrollView.showsVerticalScrollIndicator = savedShowsVerticalScrollIndicator;
            scrollView.userInteractionEnabled = savedUserInteractionEnabled;
        }
		else {
			// Saved
			CGPoint savedContentOffset = scrollView.contentOffset;
			BOOL savedShowsHorizontalScrollIndicator = scrollView.showsHorizontalScrollIndicator;
			BOOL savedShowsVerticalScrollIndicator = scrollView.showsVerticalScrollIndicator;
			BOOL savedUserInteractionEnabled = scrollView.userInteractionEnabled;

			// Hide indicators, and disable user interaction
			scrollView.showsHorizontalScrollIndicator = NO;
			scrollView.showsVerticalScrollIndicator = NO;
			scrollView.userInteractionEnabled = NO;

            // Note: not use drawViewHierarchyInRect:afterScreenUpdates: method, because
            // it will draw indicators of UIScrollView even after set indicators hidden.
            
			CGContextTranslateCTM(context, -savedContentOffset.x, -savedContentOffset.y);
			[scrollView.layer renderInContext:context];

			// Restore
			scrollView.showsHorizontalScrollIndicator = savedShowsHorizontalScrollIndicator;
			scrollView.showsVerticalScrollIndicator = savedShowsVerticalScrollIndicator;
			scrollView.userInteractionEnabled = savedUserInteractionEnabled;
		}
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();

	return image;
}

+ (nullable UIImage *)snapshotScreenIncludeStatusBar:(BOOL)includeStatusBar afterScreenUpdates:(BOOL)afterScreenUpdates {
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = includeStatusBar ? [self getStatusBarIfNeeded] : nil;
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                [window drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize} afterScreenUpdates:NO];
            }
            else {
                [window.layer renderInContext:context];
            }
        }
        
        if (statusBar) {
            [statusBar.layer renderInContext:context];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

+ (nullable UIImage *)snapshotScreenAfterOtherWindowsHasShownIncludeStatusBar:(BOOL)includeStatusBar {
    UIImage *image = nil;
    CGSize outputSize = [UIScreen mainScreen].bounds.size;
    UIView *statusBar = includeStatusBar ? [self getStatusBarIfNeeded] : nil;
    
    UIGraphicsBeginImageContextWithOptions(outputSize, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        NSArray *windows = [UIApplication sharedApplication].windows;
        BOOL hasTakeSnapshot = NO;
        
        for (UIWindow *window in windows) {
#if DEBUG_LOG
            NSLog(@"level: %f", window.windowLevel);
#endif
            if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                [window drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize }afterScreenUpdates:YES];
            }
            else {
                [window.layer renderInContext:context];
            }

            if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                NSUInteger indexOfCurrentWindow = [windows indexOfObject:window];
                if (indexOfCurrentWindow + 1 < [windows count]) {
                    UIWindow *nextWindow = windows[indexOfCurrentWindow + 1];
                    if (!hasTakeSnapshot && nextWindow.windowLevel > UIWindowLevelStatusBar) {
                        [statusBar.layer renderInContext:context];
                        hasTakeSnapshot = YES;
                    }
                }
            }
        }
        
        // Note: alert view and action sheet are NOT added to [UIApplication sharedApplication].windows any more in iOS 7+,
        // and become a solo window which is a keyWindow when shown
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [statusBar.layer renderInContext:context];
            
            if ([[[UIApplication sharedApplication] keyWindow] respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
                [[[UIApplication sharedApplication] keyWindow] drawViewHierarchyInRect:(CGRect) {CGPointZero, outputSize } afterScreenUpdates:YES];
            }
            else {
                [[[UIApplication sharedApplication] keyWindow].layer renderInContext:context];
            }
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark ::

+ (nullable UIView *)getStatusBarIfNeeded {
    UIView *statusBar = nil;
    @try {
        // iOS Simulator: 12.4/11.1/10.3.1/8.4/8.1 
        // @see https://stackoverflow.com/a/26451989
        NSString *key = [@[ @"s", @"t", @"a", @"t", @"u", @"s", @"B", @"a", @"r", @"W", @"i", @"n", @"d", @"o", @"w" ] componentsJoinedByString:@""];
        statusBar = [[UIApplication sharedApplication] valueForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"an exception occurred: %@", exception);
    }
    return statusBar;
}

#pragma mark ::

#pragma mark - Assistant Methods

#pragma mark > CGRect

+ (CGRect)safeAVMakeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect {
    if (contentSize.width <= 0 || contentSize.height <= 0) {
        return CGRectZero;
    }
    
    if (CGRectGetWidth(boundingRect) <= 0 || CGRectGetHeight(boundingRect) <= 0) {
        return CGRectZero;
    }
    
    return AVMakeRectWithAspectRatioInsideRect(contentSize, boundingRect);
}

+ (CGRect)makeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect {
    if (contentSize.width <= 0 || contentSize.height <= 0) {
        return CGRectZero;
    }
    
    if (CGRectGetWidth(boundingRect) <= 0 || CGRectGetHeight(boundingRect) <= 0) {
        return CGRectZero;
    }
    
    CGSize boundingSize = boundingRect.size;
    CGSize scaledSize = CGSizeZero;
    
    if (contentSize.width > contentSize.height) {
        // Note: landscape
        // 1. firstly scale by width ratio
        CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
        
        if (contentSize.height * ratioByWidth <= boundingSize.height) {
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
        else {
            // 2. if scale by width ratio, scaled height is still greater than boundingSize.height, then scale by height ratio
            CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
    }
    else if (contentSize.width < contentSize.height) {
        // Note: portrait
        // 1. firstly scale by height ratio
        CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
        
        if (contentSize.width * ratioByHeight <= boundingSize.width) {
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
        else {
            // 2. if scale by height ratio, scaled width is still greater than boundingSize.width, then scale by width ratio
            CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
    }
    else {
        // Note: squared
        // 1. firstly scale by width ratio
        CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
        
        if (contentSize.height * ratioByWidth <= boundingSize.height) {
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
        else {
            // 2. if scale by width ratio, scaled height is still greater than boundingSize.height, then scale by height ratio
            CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
    }

#if DEBUG
    if (scaledSize.width > boundingSize.width || scaledSize.height > boundingSize.height) {
        NSLog(@"This line should never show. Check scaledSize");
    }
#endif

    CGRect scaledRect = CGRectMake(boundingRect.origin.x + (CGRectGetWidth(boundingRect) - scaledSize.width) / 2.0, boundingRect.origin.y +  (CGRectGetHeight(boundingRect) - scaledSize.height) / 2.0, scaledSize.width, scaledSize.height);
    return scaledRect;
}

+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect {
    if (size.width <= 0 || size.height <= 0 ||
        rect.size.width <= 0 || rect.size.height <= 0) {
        return CGRectZero;
    }
    
    CGPoint origin = rect.origin;
    CGFloat deltaX = (rect.size.width - size.width) / 2.0;
    CGFloat deltaY = (rect.size.height - size.height) / 2.0;
    
    origin.x += deltaX;
    origin.y += deltaY;
    
    CGRect centeredRect = CGRectMake(origin.x, origin.y, size.width, size.height);
    return centeredRect;
}

+ (CGRect)changeFrame:(CGRect)frame newX:(CGFloat)newX newY:(CGFloat)newY newWidth:(CGFloat)newWidth newHeight:(CGFloat)newHeight {
    CGRect newFrame = frame;
    
    if (!isnan(newX)) {
        newFrame.origin.x = newX;
    }
    
    if (!isnan(newY)) {
        newFrame.origin.y = newY;
    }
    
    if (!isnan(newWidth)) {
        newFrame.size.width = newWidth;
    }
    
    if (!isnan(newHeight)) {
        newFrame.size.height = newHeight;
    }
    
    return newFrame;
}

+ (CGRect)paddedRectWithFrame:(CGRect)frame insets:(UIEdgeInsets)insets {
    if (insets.top < 0 || insets.left < 0 || insets.bottom < 0 || insets.right < 0) {
        return CGRectZero;
    }
    
    if (insets.top + insets.bottom >= frame.size.height) {
        return CGRectZero;
    }
    
    if (insets.left + insets.right >= frame.size.width) {
        return CGRectZero;
    }
    
    return CGRectMake(insets.left, insets.top, frame.size.width - insets.left - insets.right, frame.size.height - insets.top - insets.bottom);
}

#pragma mark > CGSize

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToWidth:(CGFloat)fixedWidth {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedWidth <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByWidth = (fixedWidth / contentSize.width);
    return CGSizeMake(fixedWidth, contentSize.height * ratioByWidth);
}

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToHeight:(CGFloat)fixedHeight {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedHeight <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByHeight = (fixedHeight / contentSize.height);
    return CGSizeMake(contentSize.width * ratioByHeight, fixedHeight);
}

#pragma mark > CGPoint

+ (CGPoint)changeCenter:(CGPoint)center newCX:(CGFloat)newCX newCY:(CGFloat)newCY {
    CGPoint newCenter = center;
    
    if (!isnan(newCX)) {
        newCenter.x = newCX;
    }
    
    if (!isnan(newCY)) {
        newCenter.y = newCY;
    }
    
    return newCenter;
}

#pragma mark > UIEdgeInsets

+ (BOOL)checkEdgeInsets:(UIEdgeInsets)edgeInsets containsOtherEdgeInsets:(UIEdgeInsets)otherEdgeInsets {
    if (fabs(edgeInsets.top) >= fabs(otherEdgeInsets.top) &&
        fabs(edgeInsets.left) >= fabs(otherEdgeInsets.left) &&
        fabs(edgeInsets.bottom) >= fabs(otherEdgeInsets.bottom) &&
        fabs(edgeInsets.right) >= fabs(otherEdgeInsets.right)) {
        return YES;
    }
    
    return NO;
}

#pragma mark > SafeArea

+ (UIEdgeInsets)safeAreaInsetsWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return UIEdgeInsetsZero;
    }
#ifdef __IPHONE_11_0
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return view.safeAreaInsets;
#pragma GCC diagnostic pop
    }
    else {
        return UIEdgeInsetsZero;
    }
#else
    return UIEdgeInsetsZero;
#endif
}

+ (CGRect)safeAreaFrameWithParentView:(UIView *)parentView {
    if (![parentView isKindOfClass:[UIView class]]) {
        return CGRectZero;
    }
#ifdef __IPHONE_11_0
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return [self paddedRectWithFrame:parentView.bounds insets:parentView.safeAreaInsets];
#pragma GCC diagnostic pop
    }
    else {
        return parentView.bounds;
    }
#else
    return parentView.bounds;
#endif
}

+ (CGRect)safeAreaLayoutFrameWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return CGRectZero;
    }
    
    if (!view.superview) {
        return view.bounds;
    }
    
    // Note: get safe area rect of the parent view
    CGRect safeAreaOfParentView = [WCViewTool safeAreaFrameWithParentView:view.superview];
    CGRect intersection = CGRectIntersection(safeAreaOfParentView, view.frame);
    
    if (!CGRectContainsRect(safeAreaOfParentView, view.frame) && !CGRectIsNull(intersection)) {
        CGRect newFrame = [view.superview convertRect:intersection toView:view];
        
        return newFrame;
    }
    else {
        return view.bounds;
    }
}

@end
