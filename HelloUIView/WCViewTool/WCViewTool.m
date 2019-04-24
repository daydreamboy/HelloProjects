//
//  WCViewTool.m
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"
#import <AVFoundation/AVFoundation.h>

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

#pragma mark - Hierarchy

+ (void)enumerateSubviewsInView:(UIView *)view usingBlock:(void (^)(UIView *subview, BOOL *stop))block {
    BOOL stop = NO;
    if (block) {
        // Note: pre-travse subviews for root view, so skip the block for root view
        
        NSArray *subviews = [view subviews];
        for (UIView *subview in subviews) {
            [self traverseViewHierarchyWithView:subview usinglock:block stop:&stop];
            if (stop) {
                break;
            }
        }
    }
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

+ (UIView *)addGradientLayerWithView:(UIView *)view startLeftColor:(UIColor *)startLeftColor endRightColor:(UIColor *)endRightColor {
    if (![view isKindOfClass:[UIView class]] || ![startLeftColor isKindOfClass:[UIColor class]] || ![endRightColor isKindOfClass:[UIColor class]]) {
        return view;
    }
    
    BOOL found = NO;
    for (CALayer *layer in [view.layer sublayers]) {
        if ([layer isKindOfClass:[CAGradientLayer class]] && [layer.name isEqualToString:[NSString stringWithFormat:@"gradientLayer_%p", layer]]) {
            found = YES;
            break;
        }
    }
    
    if (!found) {
        UIColor *startColor = startLeftColor;
        UIColor *finalColor = endRightColor;
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.name = [NSString stringWithFormat:@"gradientLayer_%p", gradientLayer];
        gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)finalColor.CGColor];
        gradientLayer.locations = @[ @0.0, @1.0 ];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        gradientLayer.masksToBounds = YES;
        gradientLayer.frame = view.bounds;
        [view.layer insertSublayer:gradientLayer atIndex:0];
    }
    
    return view;
}

+ (UIView *)removeGradientLayerWithView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) {
        return view;
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
    }
    
    return view;
}

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

@end
