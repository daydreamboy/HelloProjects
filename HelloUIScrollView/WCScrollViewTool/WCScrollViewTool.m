//
//  WCScrollViewTool.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/9/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCScrollViewTool.h"
#import <objc/runtime.h>

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCScrollViewObserver : NSObject
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^touchEventBlock)(UIScrollView *, UIGestureRecognizerState);
@property (nonatomic, copy) void (^scrollingEventBlock)(UIScrollView *);
@end

@implementation WCScrollViewObserver

- (instancetype)initWithScrollView:(UIScrollView *)scrollView touchEventBlock:(void (^)(UIScrollView *, UIGestureRecognizerState))touchEventBlock {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _touchEventBlock = touchEventBlock;
        
        [_scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView scrollingEventBlock:(void (^)(UIScrollView *))scrollingEventBlock {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _scrollingEventBlock = scrollingEventBlock;
        
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    @try {
        if (self.touchEventBlock) {
            [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
        }
        else if (self.scrollingEventBlock) {
            [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"an exception occurred: %@", exception);
#endif
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIScrollView *scrollView = self.scrollView;
    if (!scrollView) {
        return;
    }
    
    if (self.touchEventBlock) {
        if (object == scrollView.panGestureRecognizer && [keyPath isEqualToString:@"state"]) {
            self.touchEventBlock(scrollView, scrollView.panGestureRecognizer.state);
        }
    }
    else if (self.scrollingEventBlock) {
        if (object == scrollView && [keyPath isEqualToString:@"contentOffset"]) {
            self.scrollingEventBlock(scrollView);
        }
    }
}

@end

@implementation WCScrollViewTool

static void * const kAssociatedKeyTouchEventObserver = (void *)&kAssociatedKeyTouchEventObserver;
static void * const kAssociatedKeyScrollingEventObserver = (void *)&kAssociatedKeyScrollingEventObserver;

+ (BOOL)observeTouchEventWithScrollView:(UIScrollView *)scrollView touchEventCallback:(void (^)(UIScrollView *scrollView, UIGestureRecognizerState state))touchEventCallback {
    if (![scrollView isKindOfClass:[UIScrollView class]] || touchEventCallback == nil) {
        return NO;
    }
    
    id object = objc_getAssociatedObject(scrollView, kAssociatedKeyTouchEventObserver);
    if (object) {
        return NO;
    }
    
    WCScrollViewObserver *observer = [[WCScrollViewObserver alloc] initWithScrollView:scrollView touchEventBlock:touchEventCallback];
    objc_setAssociatedObject(scrollView, kAssociatedKeyTouchEventObserver, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

+ (BOOL)observeScrollingEventWithScrollView:(UIScrollView *)scrollView scrollingEventCallback:(void (^)(UIScrollView *scrollView))scrollingEventCallback {
    
    if (![scrollView isKindOfClass:[UIScrollView class]] || scrollingEventCallback == nil) {
        return NO;
    }
    
    id object = objc_getAssociatedObject(scrollView, kAssociatedKeyScrollingEventObserver);
    if (object) {
        return NO;
    }
    
    WCScrollViewObserver *observer = [[WCScrollViewObserver alloc] initWithScrollView:scrollView scrollingEventBlock:scrollingEventCallback];
    objc_setAssociatedObject(scrollView, kAssociatedKeyScrollingEventObserver, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

#pragma mark - Scroll to Specific Area

#pragma mark > Scroll to edges of the scroll view

+ (BOOL)scrollToTopWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, IOS11_OR_LATER ? -scrollView.adjustedContentInset.top : -scrollView.contentInset.top);
#pragma GCC diagnostic pop
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

// @see https://stackoverflow.com/a/38241928
+ (BOOL)scrollToBottomWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    // @see https://stackoverflow.com/a/38241928
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.bounds.size.height + (IOS11_OR_LATER ? scrollView.adjustedContentInset.bottom : scrollView.contentInset.bottom));
#pragma GCC diagnostic pop
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToLeftWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGPoint contentOffset = CGPointMake((IOS11_OR_LATER ? -scrollView.adjustedContentInset.left : -scrollView.contentInset.left), scrollView.contentOffset.y) ;
#pragma GCC diagnostic pop
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToRightWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGPoint contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width + (IOS11_OR_LATER ? scrollView.adjustedContentInset.right : scrollView.contentInset.right), scrollView.contentOffset.y);
#pragma GCC diagnostic pop
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

#pragma mark > Scroll to edges of the content

+ (BOOL)scrollToTopOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaTopInset = (considerSafeArea && IOS11_OR_LATER) ? scrollView.safeAreaInsets.bottom : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, 0 - safeAreaTopInset);
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToBottomOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaBottomInset = (considerSafeArea && IOS11_OR_LATER) ? scrollView.safeAreaInsets.bottom : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.bounds.size.height + safeAreaBottomInset);
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToLeftOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaLeftInset = (considerSafeArea && IOS11_OR_LATER) ? scrollView.safeAreaInsets.left : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(0 - safeAreaLeftInset, scrollView.contentOffset.y);
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

+ (BOOL)scrollToRightOfContentWithScrollView:(UIScrollView *)scrollView animated:(BOOL)animated considerSafeArea:(BOOL)considerSafeArea {
    
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
    CGFloat safeAreaRightInset = (considerSafeArea && IOS11_OR_LATER) ? scrollView.safeAreaInsets.right : 0;
#pragma GCC diagnostic pop
    
    CGPoint contentOffset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width + safeAreaRightInset, scrollView.contentOffset.y);
    [scrollView setContentOffset:contentOffset animated:animated];
    
    return YES;
}

#pragma mark - Check Scrolling Over

+ (BOOL)checkIsScrollingOverTopWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return scrollView.contentOffset.y < -scrollView.adjustedContentInset.top;
#pragma GCC diagnostic pop
    }
    else {
        return scrollView.contentOffset.y < -scrollView.contentInset.top;
    }
}

+ (BOOL)checkIsScrollingOverBottomWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height + scrollView.adjustedContentInset.bottom;
#pragma GCC diagnostic pop
    }
    else {
        return scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height + scrollView.contentInset.bottom;
    }
}

+ (BOOL)checkIsScrollingOverLeftWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return scrollView.contentOffset.x < -scrollView.adjustedContentInset.left;
#pragma GCC diagnostic pop
    }
    else {
        return scrollView.contentOffset.x < -scrollView.contentInset.left;
    }
}

+ (BOOL)checkIsScrollingOverRightWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        return scrollView.contentOffset.x + scrollView.bounds.size.width > scrollView.contentSize.width + scrollView.adjustedContentInset.right;
#pragma GCC diagnostic pop
    }
    else {
        return scrollView.contentOffset.x + scrollView.bounds.size.width > scrollView.contentSize.width + scrollView.contentInset.right;
    }
}

#pragma mark - Query

+ (CGSize)fittedContentSizeWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return CGSizeZero;
    }
    
    CGSize fittedContentSize;
    
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        fittedContentSize = CGSizeMake(scrollView.bounds.size.width - scrollView.adjustedContentInset.left - scrollView.adjustedContentInset.right, scrollView.bounds.size.height - scrollView.adjustedContentInset.top - scrollView.adjustedContentInset.bottom);
#pragma GCC diagnostic pop
    }
    else {
        fittedContentSize = CGSizeMake(scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right, scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom);
    }
    
    return fittedContentSize;
}

#pragma mark - Adjust UIScrollView

#pragma mark > Content Size

+ (BOOL)makeContentSizeToFitWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
    
    scrollView.contentSize = [self fittedContentSizeWithScrollView:scrollView];
    
    return YES;
}

#pragma mark > Content Insets

+ (BOOL)safeSetContentInsetAdjustmentBehaviorWithScrollView:(UIScrollView *)scrollView behavior:(WCScrollViewContentInsetAdjustmentBehavior)behavior {
    
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return NO;
    }
#ifdef __IPHONE_11_0
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

    if (IOS11_OR_LATER) {
        scrollView.contentInsetAdjustmentBehavior = (UIScrollViewContentInsetAdjustmentBehavior)behavior;
        
        return YES;
    }

#pragma GCC diagnostic pop
#endif
    return NO;
}

+ (UIEdgeInsets)actualContentInsetsWithScrollView:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UIScrollView class]]) {
        return UIEdgeInsetsZero;
    }
#ifdef __IPHONE_11_0
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"

    if (IOS11_OR_LATER) {
        return scrollView.adjustedContentInset;
    }

#pragma GCC diagnostic pop
#endif
    return scrollView.contentInset;
}

@end
