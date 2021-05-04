//
//  WCTableLoadMoreView.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCTableLoadMoreView.h"
#import "WCScrollViewTool.h"
#import "WCTableViewTool.h"
#import <objc/runtime.h>

#define FrameSetSize(frame, newWidth, newHeight) ({ \
CGRect __internal_frame = (frame); \
if (!isnan((newWidth))) { \
    __internal_frame.size.width = (newWidth); \
} \
if (!isnan((newHeight))) { \
    __internal_frame.size.height = (newHeight); \
} \
__internal_frame; \
})

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@class WCKVOObserver;

typedef void(^WCKVOObserverEventCallback)(id observedObject, WCKVOObserver *observer, NSDictionary<NSKeyValueChangeKey,id> *change, void *context);

@interface WCKVOObserver : NSObject
@property (nonatomic, weak, readonly) id observedObject;
@property (nonatomic, copy, readonly) WCKVOObserverEventCallback eventCallback;
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
@end

@interface WCKVOObserver ()
@property (nonatomic, weak, readwrite) id observedObject;
@property (nonatomic, copy, readwrite) WCKVOObserverEventCallback eventCallback;
@property (nonatomic, copy, readwrite) NSString *keyPath;
@property (nonatomic, assign, readwrite) NSKeyValueObservingOptions options;
@end

@implementation WCKVOObserver

- (instancetype)initWithObservedObject:(id)observedObject keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options eventCallback:(WCKVOObserverEventCallback)eventCallback  {
    self = [super init];
    if (self) {
        _observedObject = observedObject;
        _keyPath = keyPath;
        _options = options;
        _eventCallback = eventCallback;
        
        [_observedObject addObserver:self forKeyPath:keyPath options:options context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_observedObject == object && [keyPath isEqualToString:_keyPath]) {
        !_eventCallback ?: _eventCallback(_observedObject, self, change, context);
    }
}

- (void)dealloc {
    @try {
        [_observedObject removeObserver:self forKeyPath:_keyPath];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"an exception occurred: %@", exception);
#endif
    }
}

@end

static const void *kAssociatedObjectKey_WCTableLoadMoreView = &kAssociatedObjectKey_WCTableLoadMoreView;

NS_CLASS_AVAILABLE_IOS(9_0)
@interface WCTableLoadMoreView ()
@property (nonatomic, assign, readwrite) WCTableLoadMoreType loadMoreType;
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, assign) BOOL isShowingLoadMore;
@property (nonatomic, assign) BOOL finishLoadAll;
@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, assign) CGRect initialFrame;
@end

@implementation WCTableLoadMoreView

- (instancetype)initWithTableView:(UITableView *)tableView viewController:(UIViewController *)viewController frame:(CGRect)frame loadMoreType:(WCTableLoadMoreType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = tableView;
        _initialFrame = frame;
        _loadMoreType = type;
        
        if (IOS11_OR_LATER) {
            [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
        else {
            /**
             Workaround for iOS 10- KVO crash, the crash see https://developer.apple.com/forums/thread/53636.
             
             CRASH: when UITableView is deallocating, remove its observers takes no effect, and still trigger the exception:
             An instance XXX of class UITableView was deallocated while key value observers were still registered with it.
             */
            WCKVOObserver *observer = [[WCKVOObserver alloc] initWithObservedObject:_tableView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld eventCallback:^(id observedObject, WCKVOObserver *observer, NSDictionary<NSKeyValueChangeKey,id> *change, void *context) {
                [self observeValueForKeyPath:@"contentOffset" ofObject:observedObject change:change context:context];
            }];
            
            if (viewController) {
                objc_setAssociatedObject(viewController, kAssociatedObjectKey_WCTableLoadMoreView, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }

        _contentFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        [self addSubview:self.loadingIndicator];
        [self addSubview:self.labelTip];
    }
    return self;
}

- (void)dealloc {
    if (IOS11_OR_LATER) {
        [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _tableView && [keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newValue = change[NSKeyValueChangeNewKey];
        NSValue *oldValue = change[NSKeyValueChangeOldKey];
        CGPoint newPoint = [newValue CGPointValue];
        CGPoint oldPoint = [oldValue CGPointValue];
        
        if (!CGPointEqualToPoint(newPoint, oldPoint)) {
            [self startActivityIndicatorIfNeeded];
        }
    }
}

#pragma mark - Getter

- (UILabel *)labelTip {
    if (!_labelTip) {
        _labelTip = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    
    return _labelTip;
}

- (UIActivityIndicatorView *)loadingIndicator {
    if (!_loadingIndicator) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        view.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
        view.hidesWhenStopped = YES;
        
        _loadingIndicator = view;
    }
    
    return _loadingIndicator;
}

/// Start animating activity indicator
/// @note must call this method in -[UIScrollView scrollViewDidScroll:]
- (void)startActivityIndicatorIfNeeded {
    UITableView *tableView = self.tableView;
    if (tableView) {
        // Note: check content height greater than the height of the table view
        BOOL outOfTableViewHeight = tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom > tableView.bounds.size.height ? YES : NO;
        
        CGRect footerViewRectInTableView = [tableView convertRect:self.contentFrame fromView:self];
        CGRect visibleRect = tableView.bounds;
        
        if (CGRectIntersectsRect(footerViewRectInTableView, visibleRect) && outOfTableViewHeight && !self.finishLoadAll) {
            NSLog(@"startAnimating");
            [self.loadingIndicator startAnimating];
            self.labelTip.hidden = YES;
            
            if (self.willShowLoadingIndicatorBlock && !self.isRequesting) {
                self.willShowLoadingIndicatorBlock(self);
            }
        }
    }
}

- (void)stopLoadingIndicatorWithTip:(NSString *)tip hide:(BOOL)hide animatedForHide:(BOOL)animated {
    self.finishLoadAll = YES;
    [self.loadingIndicator stopAnimating];
    
    self.labelTip.text = tip;
    self.labelTip.hidden = NO;
    [self.labelTip sizeToFit];
    self.labelTip.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);;
    
    if (hide) {
        self.hidden = YES;
        
        if (self.loadMoreType == WCTableLoadMoreTypeFromTop) {
            if (animated) {
                [UIView animateWithDuration:0.25 animations:^{
                    [WCScrollViewTool scrollToTopOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
                } completion:^(BOOL finished) {
                    // @see https://stackoverflow.com/questions/341256/how-to-resize-a-tableheaderview-of-a-uitableview
                    self.frame = FrameSetSize(self.frame, NAN, 0);
                    self.tableView.tableHeaderView = self;
                    [WCScrollViewTool scrollToTopOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
                }];
            }
            else {
                self.frame = FrameSetSize(self.frame, NAN, 0);
                self.tableView.tableHeaderView = self;
                [WCScrollViewTool scrollToTopOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
            }
        }
        else if (self.loadMoreType == WCTableLoadMoreTypeFromBottom) {
            
            if (animated) {
                [UIView animateWithDuration:0.25 animations:^{
                    [WCScrollViewTool scrollToBottomOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
                } completion:^(BOOL finished) {
                    self.frame = FrameSetSize(self.frame, NAN, 0);
                    self.tableView.tableFooterView = self;
                    [WCScrollViewTool scrollToBottomOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
                }];
            }
            else {
                self.frame = FrameSetSize(self.frame, NAN, 0);
                self.tableView.tableFooterView = self;
                [WCScrollViewTool scrollToBottomOfListWithTableView:self.tableView animated:NO considerSafeArea:YES];
            }
        }
    }
}

- (void)show {
    self.hidden = NO;
    self.frame = self.initialFrame;
    
    if (self.loadMoreType == WCTableLoadMoreTypeFromTop) {
        [WCTableViewTool performOperationKeepStaticWithTableView:self.tableView block:^{
            self.tableView.tableHeaderView = self;
        }];
    }
    else if (self.loadMoreType == WCTableLoadMoreTypeFromBottom) {
        self.tableView.tableFooterView = self;
    }
}

@end
