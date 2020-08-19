//
//  WCLoadMoreTableFooterView.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLoadMoreTableFooterView.h"

@interface WCLoadMoreTableFooterView ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorLoading;
@property (nonatomic, strong) UILabel *labelTip;
@property (nonatomic, assign) BOOL isShowingLoadMore;
@property (nonatomic, assign) BOOL didLoadAll;
@end

@implementation WCLoadMoreTableFooterView

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle {
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:activityIndicatorStyle];
        _indicatorLoading.center = CGPointMake(CGRectGetWidth(frame) / 2.0, CGRectGetHeight(frame) / 2.0);
        _indicatorLoading.hidesWhenStopped = YES;
        [self addSubview:_indicatorLoading];
        
        _labelTip = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_labelTip];
    }
    return self;
}

- (void)startActivityIndicatorIfNeeded {
    UITableView *tableView = (UITableView *)[self checkAncestralViewWithView:self ancestralViewIsKindOfClass:[UITableView class]];
    if (tableView) {
        // Note: check content height greater than the height of the table view
        BOOL outOfTableViewHeight = tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom > tableView.bounds.size.height ? YES : NO;
        
        CGRect footerViewRectInTableView = [tableView convertRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) fromView:self];
        CGRect visibleRect = tableView.bounds;
        
        if (CGRectIntersectsRect(footerViewRectInTableView, visibleRect) && outOfTableViewHeight && !self.didLoadAll) {
            NSLog(@"startAnimating");
            [self.indicatorLoading startAnimating];
            self.labelTip.hidden = YES;
            
            if (self.didFirstShowActivityIndicatorBlock && !self.isRequesting) {
                self.didFirstShowActivityIndicatorBlock(self);
            }
        }
    }
}

- (void)stopActivityIndicator {
    NSLog(@"stopAnimating");
    [self.indicatorLoading stopAnimating];
}

- (void)dismissActivityIndicatorWithTip:(NSString *)tip {
    self.didLoadAll = YES;
    [self.indicatorLoading stopAnimating];
    
    self.labelTip.text = tip;
    self.labelTip.hidden = NO;
    [self.labelTip sizeToFit];
    self.labelTip.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);;
}

#pragma mark - Utility Methods

- (UIView *)checkAncestralViewWithView:(UIView *)view ancestralViewIsKindOfClass:(Class)cls {
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

@end
