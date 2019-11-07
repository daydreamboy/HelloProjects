//
//  WCScrollViewTool.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/9/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCScrollViewTool.h"
#import <objc/runtime.h>

@interface WCScrollViewObserver : NSObject
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) void (^block)(UIScrollView *, UIGestureRecognizerState);
@end

@implementation WCScrollViewObserver

- (instancetype)initWithScrollView:(UIScrollView *)scrollView block:(void (^)(UIScrollView *, UIGestureRecognizerState))block {
    self = [super init];
    if (self) {
        _scrollView = scrollView;
        _block = block;
        
        [_scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc {
    @try {
        [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
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
    
    if (object == scrollView.panGestureRecognizer && [keyPath isEqualToString:@"state"]) {
        self.block(scrollView, scrollView.panGestureRecognizer.state);
    }
}

@end

@implementation WCScrollViewTool

static void * const kAssociatedKeyObserver = (void *)&kAssociatedKeyObserver;

+ (BOOL)observeTouchEventWithScrollView:(UIScrollView *)scrollView eventCallback:(void (^)(UIScrollView *scrollView, UIGestureRecognizerState state))eventCallback {
    if (![scrollView isKindOfClass:[UIScrollView class]] || eventCallback == nil) {
        return NO;
    }
    
    id object = objc_getAssociatedObject(scrollView, kAssociatedKeyObserver);
    if (object) {
        return NO;
    }
    
    WCScrollViewObserver *observer = [[WCScrollViewObserver alloc] initWithScrollView:scrollView block:eventCallback];
    objc_setAssociatedObject(scrollView, kAssociatedKeyObserver, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

@end
